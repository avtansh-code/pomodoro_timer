//
//  CloudSyncManager.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 26/10/25.
//

import Foundation
import CloudKit
import Combine

class CloudSyncManager: ObservableObject {
    static let shared = CloudSyncManager()
    
    @Published var isSyncing: Bool = false
    @Published var syncStatus: SyncStatus = .idle
    @Published var lastSyncDate: Date?
    @Published var nextSyncDate: Date?
    @Published var isCloudAvailable: Bool = false
    
    private let container: CKContainer
    private let privateDatabase: CKDatabase
    private var cancellables = Set<AnyCancellable>()
    private var syncTimer: Timer?
    private let syncInterval: TimeInterval = 24 * 60 * 60 // 24 hours (once a day)
    
    enum SyncStatus: Equatable {
        case idle
        case syncing
        case success
        case error(String)
        
        var message: String {
            switch self {
            case .idle: return "Ready to sync"
            case .syncing: return "Syncing..."
            case .success: return "Sync complete"
            case .error(let message): return "Error: \(message)"
            }
        }
    }
    
    private init() {
        // Use explicit container identifier to match entitlements
        let containerIdentifier = "iCloud.avtanshgupta.PomodoroTimer"
        container = CKContainer(identifier: containerIdentifier)
        privateDatabase = container.privateCloudDatabase
        
        checkCloudAvailability()
    }
    
    // MARK: - Automatic Sync
    
    func startAutomaticSync() {
        stopAutomaticSync()
        
        // Schedule next sync
        nextSyncDate = Date().addingTimeInterval(syncInterval)
        
        syncTimer = Timer.scheduledTimer(withTimeInterval: syncInterval, repeats: true) { [weak self] _ in
            self?.performAutomaticSync()
        }
    }
    
    func stopAutomaticSync() {
        syncTimer?.invalidate()
        syncTimer = nil
        nextSyncDate = nil
    }
    
    private func performAutomaticSync() {
        guard isCloudAvailable, !isSyncing else { return }
        
        // Sync settings
        let settings = PersistenceManager.shared.loadSettings()
        syncSettings(settings)
        
        // Sync all sessions
        let sessions = PersistenceManager.shared.getAllSessions()
        if !sessions.isEmpty {
            syncAllSessions(sessions)
        }
        
        // Schedule next sync
        nextSyncDate = Date().addingTimeInterval(syncInterval)
    }
    
    // MARK: - Cloud Availability
    
    func checkCloudAvailability() {
        container.accountStatus { [weak self] status, error in
            DispatchQueue.main.async {
                self?.isCloudAvailable = (status == .available)
                
                if let error = error {
                    print("iCloud account status error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Settings Sync
    
    func syncSettings(_ settings: TimerSettings) {
        guard isCloudAvailable else {
            syncStatus = .error("iCloud not available")
            return
        }
        
        isSyncing = true
        syncStatus = .syncing
        
        // Create record with a unique ID for settings (we only want one settings record per user)
        let recordID = CKRecord.ID(recordName: "UserSettings")
        let record = CKRecord(recordType: "Settings", recordID: recordID)
        
        record["focusDuration"] = settings.focusDuration as CKRecordValue
        record["shortBreakDuration"] = settings.shortBreakDuration as CKRecordValue
        record["longBreakDuration"] = settings.longBreakDuration as CKRecordValue
        record["sessionsUntilLongBreak"] = settings.sessionsUntilLongBreak as CKRecordValue
        record["autoStartBreaks"] = (settings.autoStartBreaks ? 1 : 0) as CKRecordValue
        record["autoStartFocus"] = (settings.autoStartFocus ? 1 : 0) as CKRecordValue
        record["soundEnabled"] = (settings.soundEnabled ? 1 : 0) as CKRecordValue
        record["hapticEnabled"] = (settings.hapticEnabled ? 1 : 0) as CKRecordValue
        record["notificationsEnabled"] = (settings.notificationsEnabled ? 1 : 0) as CKRecordValue
        record["selectedTheme"] = settings.selectedTheme.rawValue as CKRecordValue
        record["focusModeEnabled"] = (settings.focusModeEnabled ? 1 : 0) as CKRecordValue
        record["syncWithFocusMode"] = (settings.syncWithFocusMode ? 1 : 0) as CKRecordValue
        record["lastModified"] = Date() as CKRecordValue
        
        privateDatabase.save(record) { [weak self] savedRecord, error in
            DispatchQueue.main.async {
                self?.isSyncing = false
                
                if let error = error {
                    self?.syncStatus = .error(error.localizedDescription)
                    print("⚠️ Settings sync error: \(error)")
                    print("💡 Note: If this is your first sync, the CloudKit schema will be created automatically in Development mode.")
                    print("📝 Check CloudKit Dashboard: https://icloud.developer.apple.com/dashboard/")
                } else {
                    self?.syncStatus = .success
                    self?.lastSyncDate = Date()
                    print("✅ Settings synced successfully")
                    print("🔍 View in CloudKit Dashboard: https://icloud.developer.apple.com/dashboard/")
                }
            }
        }
    }
    
    func fetchSettings(completion: @escaping (TimerSettings?) -> Void) {
        guard isCloudAvailable else {
            completion(nil)
            return
        }
        
        let query = CKQuery(recordType: "Settings", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "lastModified", ascending: false)]
        
        privateDatabase.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults) { result in
            switch result {
            case .success(let (matchResults, _)):
                guard let firstMatch = matchResults.first else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                
                switch firstMatch.1 {
                case .success(let record):
                    Task { @MainActor in
                        let settings = TimerSettings(
                            focusDuration: record["focusDuration"] as? TimeInterval ?? 25 * 60,
                            shortBreakDuration: record["shortBreakDuration"] as? TimeInterval ?? 5 * 60,
                            longBreakDuration: record["longBreakDuration"] as? TimeInterval ?? 15 * 60,
                            sessionsUntilLongBreak: record["sessionsUntilLongBreak"] as? Int ?? 4,
                            autoStartBreaks: record["autoStartBreaks"] as? Bool ?? false,
                            autoStartFocus: record["autoStartFocus"] as? Bool ?? false,
                            soundEnabled: record["soundEnabled"] as? Bool ?? true,
                            hapticEnabled: record["hapticEnabled"] as? Bool ?? true,
                            notificationsEnabled: record["notificationsEnabled"] as? Bool ?? true,
                            selectedTheme: TimerSettings.AppTheme(rawValue: record["selectedTheme"] as? String ?? "System") ?? .system,
                            focusModeEnabled: record["focusModeEnabled"] as? Bool ?? false,
                            syncWithFocusMode: record["syncWithFocusMode"] as? Bool ?? false
                        )
                        
                        completion(settings)
                    }
                case .failure(let error):
                    print("Fetch settings record error: \(error)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            case .failure(let error):
                print("Fetch settings error: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    // MARK: - Session Sync
    
    func syncSession(_ session: TimerSession) {
        guard isCloudAvailable else {
            syncStatus = .error("iCloud not available")
            return
        }
        
        // Use session ID as record name for uniqueness
        let recordID = CKRecord.ID(recordName: session.id.uuidString)
        let record = CKRecord(recordType: "Session", recordID: recordID)
        
        record["sessionId"] = session.id.uuidString as CKRecordValue
        record["type"] = session.type.rawValue as CKRecordValue
        record["duration"] = session.duration as CKRecordValue
        record["completedAt"] = session.completedAt as CKRecordValue
        
        privateDatabase.save(record) { savedRecord, error in
            if let error = error {
                print("⚠️ Session sync error: \(error)")
                print("💡 Note: If this is your first sync, the CloudKit schema will be created automatically in Development mode.")
            } else {
                print("✅ Session synced successfully")
            }
        }
    }
    
    func fetchSessions(completion: @escaping ([TimerSession]) -> Void) {
        guard isCloudAvailable else {
            completion([])
            return
        }
        
        let query = CKQuery(recordType: "Session", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "completedAt", ascending: false)]
        
        privateDatabase.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults) { result in
            switch result {
            case .success(let (matchResults, _)):
                let sessions = matchResults.compactMap { matchResult -> TimerSession? in
                    guard case .success(let record) = matchResult.1,
                          let sessionIdString = record["sessionId"] as? String,
                          let sessionId = UUID(uuidString: sessionIdString),
                          let typeString = record["type"] as? String,
                          let type = SessionType(rawValue: typeString),
                          let duration = record["duration"] as? TimeInterval,
                          let completedAt = record["completedAt"] as? Date else {
                        return nil
                    }
                    
                    return TimerSession(
                        id: sessionId,
                        type: type,
                        duration: duration,
                        completedAt: completedAt
                    )
                }
                
                DispatchQueue.main.async {
                    completion(sessions)
                }
            case .failure(let error):
                print("Fetch sessions error: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    // MARK: - Batch Operations
    
    func syncAllSessions(_ sessions: [TimerSession]) {
        guard isCloudAvailable else {
            syncStatus = .error("iCloud not available")
            return
        }
        
        isSyncing = true
        syncStatus = .syncing
        
        // Use session IDs as record names to prevent duplicates
        let records = sessions.map { session -> CKRecord in
            let recordID = CKRecord.ID(recordName: session.id.uuidString)
            let record = CKRecord(recordType: "Session", recordID: recordID)
            record["sessionId"] = session.id.uuidString as CKRecordValue
            record["type"] = session.type.rawValue as CKRecordValue
            record["duration"] = session.duration as CKRecordValue
            record["completedAt"] = session.completedAt as CKRecordValue
            return record
        }
        
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInitiated
        
        operation.modifyRecordsResultBlock = { [weak self] result in
            DispatchQueue.main.async {
                self?.isSyncing = false
                
                switch result {
                case .success:
                    self?.syncStatus = .success
                    self?.lastSyncDate = Date()
                    print("✅ All sessions synced successfully")
                    print("🔍 View in CloudKit Dashboard: https://icloud.developer.apple.com/dashboard/")
                case .failure(let error):
                    self?.syncStatus = .error(error.localizedDescription)
                    print("⚠️ Batch sync error: \(error)")
                    print("💡 Note: If this is your first sync, the CloudKit schema will be created automatically in Development mode.")
                }
            }
        }
        
        privateDatabase.add(operation)
    }
    
    // MARK: - Delete iCloud Data
    
    func deleteAllCloudData(completion: @escaping (Bool) -> Void) {
        guard isCloudAvailable else {
            print("iCloud not available for deletion")
            DispatchQueue.main.async { completion(false) }
            return
        }
        
        print("Starting iCloud data deletion...")
        
        // Delete all settings using query operation
        deleteRecordsOfType("Settings") { [weak self] success in
            guard let self = self else {
                DispatchQueue.main.async { completion(false) }
                return
            }
            
            if success {
                print("Settings deleted successfully, proceeding to sessions...")
                // Continue to delete sessions
                self.deleteRecordsOfType("Session", completion: completion)
            } else {
                print("Failed to delete settings")
                DispatchQueue.main.async { completion(false) }
            }
        }
    }
    
    private func deleteRecordsOfType(_ recordType: String, completion: @escaping (Bool) -> Void) {
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.qualityOfService = .userInitiated
        
        var recordIDsToDelete: [CKRecord.ID] = []
        
        queryOperation.recordMatchedBlock = { recordID, result in
            switch result {
            case .success:
                recordIDsToDelete.append(recordID)
            case .failure(let error):
                print("Error matching record \(recordID): \(error.localizedDescription)")
            }
        }
        
        queryOperation.queryResultBlock = { [weak self] result in
            guard let self = self else {
                DispatchQueue.main.async { completion(false) }
                return
            }
            
            switch result {
            case .success:
                if recordIDsToDelete.isEmpty {
                    print("No \(recordType) records to delete")
                    DispatchQueue.main.async { completion(true) }
                } else {
                    print("Deleting \(recordIDsToDelete.count) \(recordType) record(s)...")
                    self.deleteRecords(recordIDsToDelete, completion: completion)
                }
            case .failure(let error):
                print("Failed to query \(recordType) for deletion: \(error.localizedDescription)")
                DispatchQueue.main.async { completion(false) }
            }
        }
        
        privateDatabase.add(queryOperation)
    }
    
    private func deleteRecords(_ recordIDs: [CKRecord.ID], completion: @escaping (Bool) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: recordIDs)
        operation.qualityOfService = .userInitiated
        
        operation.modifyRecordsResultBlock = { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Records deleted successfully")
                    completion(true)
                case .failure(let error):
                    print("Failed to delete records: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
        
        privateDatabase.add(operation)
    }
    
    // MARK: - Merge Strategies
    
    func mergeWithCloud(localSettings: TimerSettings, completion: @escaping (TimerSettings) -> Void) {
        fetchSettings { cloudSettings in
            guard let cloudSettings = cloudSettings else {
                // No cloud data, use local
                completion(localSettings)
                return
            }
            
            // Simple last-write-wins strategy
            // In production, you might want more sophisticated merging
            completion(cloudSettings)
        }
    }
    
    func mergeSessions(localSessions: [TimerSession], completion: @escaping ([TimerSession]) -> Void) {
        fetchSessions { cloudSessions in
            // Merge by unique ID, prefer cloud version on conflict
            var mergedSessions: [UUID: TimerSession] = [:]
            
            // Add local sessions
            for session in localSessions {
                mergedSessions[session.id] = session
            }
            
            // Override with cloud sessions (last-write-wins)
            for session in cloudSessions {
                mergedSessions[session.id] = session
            }
            
            let merged = Array(mergedSessions.values).sorted { $0.completedAt > $1.completedAt }
            completion(merged)
        }
    }
}

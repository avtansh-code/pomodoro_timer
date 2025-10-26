//
//  TimerSessionTests.swift
//  PomodoroTimerTests
//
//  Created by XCTest Suite
//

import XCTest
@testable import PomodoroTimer

final class TimerSessionTests: XCTestCase {
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testTimerSessionInitialization() {
        let session = TimerSession(type: .focus, duration: 1500)
        
        XCTAssertNotNil(session.id, "Session should have an ID")
        XCTAssertEqual(session.type, .focus, "Session type should be focus")
        XCTAssertEqual(session.duration, 1500, "Duration should be 1500 seconds")
        XCTAssertNotNil(session.completedAt, "Completed date should not be nil")
    }
    
    func testTimerSessionWithCustomDate() {
        let customDate = Date(timeIntervalSinceNow: -3600) // 1 hour ago
        let session = TimerSession(type: .shortBreak, duration: 300, completedAt: customDate)
        
        XCTAssertEqual(session.completedAt, customDate, "Completed date should match custom date")
    }
    
    func testTimerSessionWithCustomID() {
        let customID = UUID()
        let session = TimerSession(id: customID, type: .longBreak, duration: 900)
        
        XCTAssertEqual(session.id, customID, "Session ID should match custom ID")
    }
    
    // MARK: - SessionType Tests
    
    func testSessionTypeRawValues() {
        XCTAssertEqual(SessionType.focus.rawValue, "Focus")
        XCTAssertEqual(SessionType.shortBreak.rawValue, "Short Break")
        XCTAssertEqual(SessionType.longBreak.rawValue, "Long Break")
    }
    
    func testSessionTypeFromRawValue() {
        XCTAssertEqual(SessionType(rawValue: "Focus"), .focus)
        XCTAssertEqual(SessionType(rawValue: "Short Break"), .shortBreak)
        XCTAssertEqual(SessionType(rawValue: "Long Break"), .longBreak)
        XCTAssertNil(SessionType(rawValue: "Invalid"))
    }
    
    // MARK: - Codable Tests
    
    func testTimerSessionEncoding() throws {
        let session = TimerSessionFactory.createFocusSession()
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(session)
        
        XCTAssertFalse(data.isEmpty, "Encoded data should not be empty")
    }
    
    func testTimerSessionDecoding() throws {
        let originalSession = TimerSessionFactory.createFocusSession()
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(originalSession)
        
        let decoder = JSONDecoder()
        let decodedSession = try decoder.decode(TimerSession.self, from: data)
        
        XCTAssertEqual(decodedSession.id, originalSession.id)
        XCTAssertEqual(decodedSession.type, originalSession.type)
        XCTAssertEqual(decodedSession.duration, originalSession.duration)
        XCTAssertEqual(decodedSession.completedAt.timeIntervalSince1970, 
                      originalSession.completedAt.timeIntervalSince1970, 
                      accuracy: 0.001)
    }
    
    func testTimerSessionEncodingDecoding() throws {
        let sessions = [
            TimerSessionFactory.createFocusSession(),
            TimerSessionFactory.createShortBreakSession(),
            TimerSessionFactory.createLongBreakSession()
        ]
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(sessions)
        
        let decoder = JSONDecoder()
        let decodedSessions = try decoder.decode([TimerSession].self, from: data)
        
        XCTAssertEqual(decodedSessions.count, sessions.count)
        
        for (decoded, original) in zip(decodedSessions, sessions) {
            XCTAssertEqual(decoded.id, original.id)
            XCTAssertEqual(decoded.type, original.type)
            XCTAssertEqual(decoded.duration, original.duration)
        }
    }
    
    func testSessionTypeCodable() throws {
        let types: [SessionType] = [.focus, .shortBreak, .longBreak]
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(types)
        
        let decoder = JSONDecoder()
        let decodedTypes = try decoder.decode([SessionType].self, from: data)
        
        XCTAssertEqual(decodedTypes, types)
    }
    
    // MARK: - Identifiable Tests
    
    func testTimerSessionIdentifiable() {
        let session1 = TimerSessionFactory.createFocusSession()
        let session2 = TimerSessionFactory.createFocusSession()
        
        XCTAssertNotEqual(session1.id, session2.id, "Different sessions should have unique IDs")
    }
    
    func testTimerSessionInCollection() {
        let sessions = [
            TimerSessionFactory.createFocusSession(),
            TimerSessionFactory.createShortBreakSession(),
            TimerSessionFactory.createLongBreakSession()
        ]
        
        // Test that we can use sessions in collections that require Identifiable
        let sessionDictionary = Dictionary(uniqueKeysWithValues: sessions.map { ($0.id, $0) })
        
        XCTAssertEqual(sessionDictionary.count, 3)
    }
    
    // MARK: - Comparison Tests
    
    func testTimerSessionSorting() {
        let now = Date()
        let session1 = TimerSession(type: .focus, duration: 1500, completedAt: now.addingTimeInterval(-3600))
        let session2 = TimerSession(type: .focus, duration: 1500, completedAt: now.addingTimeInterval(-1800))
        let session3 = TimerSession(type: .focus, duration: 1500, completedAt: now)
        
        let sessions = [session2, session3, session1]
        let sortedSessions = sessions.sorted { $0.completedAt < $1.completedAt }
        
        XCTAssertEqual(sortedSessions[0].id, session1.id)
        XCTAssertEqual(sortedSessions[1].id, session2.id)
        XCTAssertEqual(sortedSessions[2].id, session3.id)
    }
    
    // MARK: - Edge Cases
    
    func testTimerSessionWithZeroDuration() {
        let session = TimerSession(type: .focus, duration: 0)
        
        XCTAssertEqual(session.duration, 0)
    }
    
    func testTimerSessionWithLargeDuration() {
        let largeDuration: TimeInterval = 24 * 60 * 60 // 24 hours
        let session = TimerSession(type: .focus, duration: largeDuration)
        
        XCTAssertEqual(session.duration, largeDuration)
    }
    
    func testTimerSessionWithFutureDate() {
        let futureDate = Date(timeIntervalSinceNow: 3600)
        let session = TimerSession(type: .focus, duration: 1500, completedAt: futureDate)
        
        XCTAssertEqual(session.completedAt, futureDate)
    }
}

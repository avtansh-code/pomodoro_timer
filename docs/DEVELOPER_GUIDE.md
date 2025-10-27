# 🛠️ Mr. Pomodoro - Developer Guide

**Version:** 1.1.0  
**Last Updated:** January 26, 2026  
**Xcode:** 26.0.1  
**iOS SDK:** 26.0  
**Swift:** 5.0+

This guide provides comprehensive technical documentation for developers working on the Pomodoro Timer iOS application.

---

## 📖 Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Development Setup](#development-setup)
3. [Project Structure](#project-structure)
4. [Testing Strategy](#testing-strategy)
5. [iCloud Integration](#icloud-integration)
6. [Focus Mode Integration](#focus-mode-integration)
7. [Background Execution](#background-execution)
8. [Performance Optimization](#performance-optimization)
9. [Debugging & Troubleshooting](#debugging--troubleshooting)
10. [CI/CD Configuration](#cicd-configuration)

---

## Architecture Overview

### Design Pattern

The app follows the **MVVM (Model-View-ViewModel)** architectural pattern with SwiftUI.

```
┌─────────────────────────────────────────┐
│              Views (SwiftUI)             │
│  MainTimerView, SettingsView, etc.      │
└─────────────────────────────────────────┘
                    ↕️
┌─────────────────────────────────────────┐
│         ViewModels/Managers              │
│  TimerManager, ThemeManager, etc.        │
└─────────────────────────────────────────┘
                    ↕️
┌─────────────────────────────────────────┐
│              Models                      │
│  TimerSession, TimerSettings, AppTheme   │
└─────────────────────────────────────────┘
                    ↕️
┌─────────────────────────────────────────┐
│             Services                     │
│  PersistenceManager, CloudSyncManager    │
└─────────────────────────────────────────┘
```

### Core Components

**Models**
- `TimerSession` - Represents a completed work/break session
- `TimerSettings` - User preferences and configuration
- `AppTheme` - Theme definitions and color schemes
- `SessionType` - Enum for Focus/ShortBreak/LongBreak

**Services**
- `TimerManager` - Core timer logic and state management
- `PersistenceManager` - Local data storage (UserDefaults)
- `CloudSyncManager` - iCloud sync via CloudKit
- `ThemeManager` - Theme selection and persistence
- `FocusModeManager` - Focus Mode integration

**Views**
- `MainTimerView` - Primary timer interface
- `StatisticsView` - Analytics and progress tracking
- `SettingsView` - User preferences and configuration
- `PrivacyPolicyView` - Privacy policy display

### State Management

**ObservableObject**
- Managers use `@Published` properties for reactive updates
- Views observe with `@StateObject` or `@ObservedObject`
- SwiftUI automatically refreshes on state changes

**AppStorage**
- Theme preferences: `@AppStorage("selectedThemeId")`
- Simple settings stored directly
- Automatic synchronization with UserDefaults

**Environment**
- Theme propagated via `.environment(\.appTheme, theme)`
- Accessible in any child view
- Supports dynamic theme switching

### Data Flow

```
User Action → View → Manager → Model → Service → Storage
                ↓
            State Update
                ↓
           View Refresh
```

---

## Development Setup

### Requirements

- **macOS:** 12.0 or later
- **Xcode:** 26.0.1 or later
- **iOS Deployment Target:** 18.0+
- **Swift:** 5.0+
- **Apple Developer Account:** Required for iCloud

### Initial Setup

1. **Clone the Repository**
```bash
git clone <repository-url>
cd PomodoroTimer
```

2. **Open in Xcode**
```bash
open PomodoroTimer.xcodeproj
```

3. **Configure Signing**
   - Select PomodoroTimer target
   - Go to Signing & Capabilities
   - Select your Team
   - Xcode will automatically manage provisioning

4. **Configure iCloud** (Optional for development)
   - Enable iCloud capability
   - Select or create CloudKit container
   - See [iCloud Integration](#icloud-integration) section

5. **Build and Run**
```bash
# Command line
xcodebuild -project PomodoroTimer.xcodeproj \
  -scheme PomodoroTimer \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  build

# Or use Xcode: Cmd+R
```

### Development Tips

**Simulator vs Device**
- Most features work on simulator
- iCloud sync requires real device or signed-in simulator
- Haptic feedback requires real device
- Focus Mode requires iOS 16.1+ device

**Debugging Tools**
- **Instruments:** For performance profiling
- **Memory Graph:** For memory leak detection
- **View Hierarchy:** For UI debugging
- **Network Link Conditioner:** For iCloud testing

---

## Project Structure

```
PomodoroTimer/
├── PomodoroTimerApp.swift      # App entry point
├── ContentView.swift            # Root navigation view
├── Info.plist                   # App configuration
├── LaunchScreen.storyboard      # Launch screen
├── PomodoroTimer.entitlements   # Capabilities
│
├── Models/
│   ├── TimerSession.swift       # Session data model
│   ├── TimerSettings.swift      # Settings data model
│   └── AppTheme.swift           # Theme definitions
│
├── Views/
│   ├── MainTimerView.swift      # Main timer interface
│   ├── StatisticsView.swift     # Stats and analytics
│   ├── SettingsView.swift       # User settings
│   └── PrivacyPolicyView.swift  # Privacy policy
│
├── Services/
│   ├── TimerManager.swift       # Timer logic
│   ├── PersistenceManager.swift # Local storage
│   ├── CloudSyncManager.swift   # iCloud sync
│   ├── ThemeManager.swift       # Theme management
│   └── FocusModeManager.swift   # Focus Mode integration
│
├── AppIntents/
│   ├── StartPomodoroIntent.swift
│   ├── PauseTimerIntent.swift
│   ├── ResumeTimerIntent.swift
│   ├── ResetTimerIntent.swift
│   ├── ShowStatisticsIntent.swift
│   └── PomodoroShortcuts.swift
│
└── Assets.xcassets/
    ├── AppIcon.appiconset/
    └── AccentColor.colorset/

PomodoroTimerTests/
├── UnitTests/
│   ├── TimerSessionTests.swift
│   ├── TimerSettingsTests.swift
│   ├── TimerManagerTests.swift
│   └── PersistenceManagerTests.swift
│
└── TestUtilities/
    ├── MockUserDefaults.swift
    ├── TestConstants.swift
    ├── TimerSessionFactory.swift
    ├── TimerSettingsFactory.swift
    └── XCTestCase+Extensions.swift

PomodoroTimerPerformanceTests/
└── TimerPerformanceTests.swift

PomodoroTimerUITests/
├── MainTimerUITests.swift
└── SettingsUITests.swift
```

### Key Files

**PomodoroTimerApp.swift**
- App lifecycle management
- Initializes managers
- Sets up environment

**TimerManager.swift**
- Core timer logic (start, pause, resume, reset)
- Session type transitions
- Background/foreground handling
- Notification scheduling

**CloudSyncManager.swift**
- CloudKit integration
- Settings and session synchronization
- Conflict resolution
- Error handling

**ThemeManager.swift**
- Theme selection logic
- Persistence via @AppStorage
- Available themes catalog

---

## Testing Strategy

### Test Suite Overview

- **Unit Tests:** Model and business logic validation
- **Performance Tests:** Timer accuracy and data handling
- **UI Tests:** User interaction workflows

### Coverage Goals

- **Unit Tests:** >90% code coverage
- **Critical Paths:** 100% (timer logic, data persistence)
- **Performance:** All benchmarks within thresholds
- **UI Tests:** Complete user journeys

### Running Tests

**All Tests**
```bash
# Command line
xcodebuild test \
  -project PomodoroTimer.xcodeproj \
  -scheme PomodoroTimer \
  -destination 'platform=iOS Simulator,name=iPhone 17'

# Xcode: Cmd+U
```

**Specific Test Target**
```bash
# Unit tests only
xcodebuild test \
  -project PomodoroTimer.xcodeproj \
  -scheme PomodoroTimer \
  -only-testing:PomodoroTimerTests

# Performance tests only
xcodebuild test \
  -project PomodoroTimer.xcodeproj \
  -scheme PomodoroTimer \
  -only-testing:PomodoroTimerPerformanceTests

# UI tests only
xcodebuild test \
  -project PomodoroTimer.xcodeproj \
  -scheme PomodoroTimer \
  -only-testing:PomodoroTimerUITests
```

**Specific Test Class**
```bash
xcodebuild test \
  -project PomodoroTimer.xcodeproj \
  -scheme PomodoroTimer \
  -only-testing:PomodoroTimerTests/TimerManagerTests
```

### Unit Tests

#### TimerSessionTests
Tests the TimerSession model:
- Session initialization and properties
- SessionType enum functionality
- Codable conformance
- Sorting and comparison
- Edge cases (zero duration, future dates)

```swift
func testSessionInitialization() {
    let session = TimerSession(
        type: .focus,
        duration: 1500,
        completedAt: Date()
    )
    XCTAssertEqual(session.type, .focus)
    XCTAssertEqual(session.duration, 1500)
}
```

#### TimerSettingsTests
Tests the TimerSettings class:
- Default and custom initialization
- Observable object behavior
- Codable implementation
- Validation logic
- Theme enum functionality

```swift
func testDefaultSettings() {
    let settings = TimerSettings()
    XCTAssertEqual(settings.focusDuration, 25 * 60)
    XCTAssertEqual(settings.shortBreakDuration, 5 * 60)
    XCTAssertEqual(settings.longBreakDuration, 15 * 60)
}
```

#### TimerManagerTests
Tests core timer logic:
- Timer lifecycle (start, pause, resume, reset)
- Session switching logic
- Completion counting
- Background/foreground behavior
- Auto-start functionality
- State updates

```swift
func testStartTimer() {
    let manager = TimerManager()
    manager.startTimer()
    
    XCTAssertTrue(manager.isRunning)
    XCTAssertFalse(manager.isPaused)
    XCTAssertEqual(manager.currentSessionType, .focus)
}
```

#### PersistenceManagerTests
Tests data persistence:
- Settings save/load
- Session storage and retrieval
- Statistics calculations
- Streak logic
- Data clearing
- Large dataset handling

```swift
func testSaveAndLoadSettings() {
    let manager = PersistenceManager()
    let settings = TimerSettings()
    settings.focusDuration = 30 * 60
    
    manager.saveSettings(settings)
    let loaded = manager.loadSettings()
    
    XCTAssertEqual(loaded.focusDuration, 30 * 60)
}
```

### Performance Tests

#### TimerPerformanceTests
Measures timer accuracy and performance:

```swift
func testTimerAccuracy() {
    measure {
        // Measure timer accuracy over 25 minutes
        // Threshold: ±1 second
    }
}

func testRapidStateChecks() {
    measure {
        for _ in 0..<1000 {
            _ = timerManager.isRunning
            _ = timerManager.remainingTime
        }
    }
    // Benchmark: <1ms per 1000 checks
}
```

**Benchmarks:**
- Timer accuracy: ±1 second over 25 minutes
- State check overhead: <1ms per 1000 checks
- Session switch: <10ms
- Settings save: <50ms
- Session load: <100ms for 1000+ sessions

### UI Tests

#### MainTimerUITests
Tests main timer interface:
- App launch and initial state
- Button interactions
- Timer state transitions
- Session type display
- Navigation
- Accessibility

```swift
func testStartTimer() {
    let app = XCUIApplication()
    app.launch()
    
    let startButton = app.buttons["Start"]
    XCTAssertTrue(startButton.exists)
    
    startButton.tap()
    
    let pauseButton = app.buttons["Pause"]
    XCTAssertTrue(pauseButton.waitForExistence(timeout: 1))
}
```

#### SettingsUITests
Tests settings screen:
- Settings navigation
- Toggle switches
- Theme selection
- Duration controls
- Settings persistence

```swift
func testThemeSelection() {
    let app = XCUIApplication()
    app.launch()
    
    app.tabBars.buttons["Settings"].tap()
    
    let oceanBlueTheme = app.buttons["Ocean Blue"]
    oceanBlueTheme.tap()
    
    // Verify theme applied
    XCTAssertTrue(oceanBlueTheme.isSelected)
}
```

### Test Utilities

**MockUserDefaults**
```swift
class MockUserDefaults: UserDefaults {
    private var storage: [String: Any] = [:]
    
    override func set(_ value: Any?, forKey key: String) {
        storage[key] = value
    }
    
    override func object(forKey key: String) -> Any? {
        return storage[key]
    }
}
```

**Factory Methods**
```swift
extension TimerSession {
    static func mockFocusSession() -> TimerSession {
        TimerSession(
            type: .focus,
            duration: 1500,
            completedAt: Date()
        )
    }
}
```

### Best Practices

**Writing Tests**
- Use descriptive test names: `testStartTimerUpdatesState`
- Keep tests focused and atomic
- Use setup/tearDown for initialization/cleanup
- Test edge cases and error conditions
- Use expectations for async operations

**Test Organization**
- Group related tests with `// MARK:` comments
- Maintain clear test structure
- Document complex test scenarios
- Keep tests independent

**Async Testing**
```swift
func testAsyncOperation() {
    let expectation = XCTestExpectation(description: "Async operation")
    
    performAsyncOperation { result in
        XCTAssertTrue(result)
        expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 5.0)
}
```

---

## iCloud Integration

### CloudKit Setup

#### Prerequisites

1. **Apple Developer Account**
   - Free account: Development testing only
   - Paid account ($99/year): App Store distribution

2. **Xcode Configuration**
   - Xcode 14.0 or later
   - macOS 12.0 or later
   - iOS 16.0+ deployment target

#### Step-by-Step Setup

**1. Enable iCloud Capability**

```bash
1. Open PomodoroTimer.xcodeproj in Xcode
2. Select PomodoroTimer target
3. Go to Signing & Capabilities tab
4. Click + Capability button
5. Select iCloud
6. Check CloudKit checkbox
7. Container automatically created
```

**2. Configure Container**

Default container ID:
```
iCloud.com.yourteam.PomodoroTimer
```

To customize:
```bash
1. Click + button under Containers
2. Enter custom container ID
3. Or use default (recommended)
```

**3. Add Background Modes** (Optional)

```bash
1. Click + Capability
2. Select Background Modes
3. Check:
   ☑️ Remote notifications
   ☑️ Background fetch
```

**4. Update App Identifier**

```bash
1. Go to developer.apple.com
2. Navigate to Certificates, Identifiers & Profiles
3. Select your App ID
4. Enable iCloud capability
5. Configure CloudKit containers
6. Save changes
```

**5. Regenerate Provisioning Profile**

```bash
1. Xcode → Preferences → Accounts
2. Select your Apple ID
3. Click Download Manual Profiles
4. Or delete existing and let Xcode recreate
```

### CloudKit Schema

#### Record Types

**Settings Record**
```swift
Type: Settings
Fields:
  - focusDuration: Double
  - shortBreakDuration: Double
  - longBreakDuration: Double
  - sessionsUntilLongBreak: Int
  - autoStartBreaks: Bool
  - autoStartFocus: Bool
  - soundEnabled: Bool
  - hapticEnabled: Bool
  - notificationsEnabled: Bool
  - selectedTheme: String
  - focusModeEnabled: Bool
  - syncWithFocusMode: Bool
  - lastModified: Date
```

**Session Record**
```swift
Type: Session
Fields:
  - sessionId: String (UUID)
  - type: String (Focus/ShortBreak/LongBreak)
  - duration: Double
  - completedAt: Date
```

### CloudSyncManager Implementation

#### Key Methods

**Check Cloud Availability**
```swift
func checkCloudAvailability() async -> Bool {
    do {
        let status = try await CKContainer.default().accountStatus()
        return status == .available
    } catch {
        print("Cloud availability check failed: \(error)")
        return false
    }
}
```

**Sync Settings**
```swift
func syncSettings(_ settings: TimerSettings) async throws {
    let record = CKRecord(recordType: "Settings")
    record["focusDuration"] = settings.focusDuration as CKRecordValue
    record["shortBreakDuration"] = settings.shortBreakDuration as CKRecordValue
    // ... other fields
    
    let database = CKContainer.default().privateCloudDatabase
    try await database.save(record)
}
```

**Fetch Settings**
```swift
func fetchSettings() async throws -> TimerSettings? {
    let database = CKContainer.default().privateCloudDatabase
    let query = CKQuery(recordType: "Settings", predicate: NSPredicate(value: true))
    
    let results = try await database.records(matching: query)
    guard let record = results.matchResults.first?.1 else {
        return nil
    }
    
    // Parse record into TimerSettings
    return parseSettings(from: try record.get())
}
```

**Sync Sessions**
```swift
func syncAllSessions(_ sessions: [TimerSession]) async throws {
    let records = sessions.map { session -> CKRecord in
        let record = CKRecord(recordType: "Session")
        record["sessionId"] = session.id.uuidString as CKRecordValue
        record["type"] = session.type.rawValue as CKRecordValue
        record["duration"] = session.duration as CKRecordValue
        record["completedAt"] = session.completedAt as CKRecordValue
        return record
    }
    
    let database = CKContainer.default().privateCloudDatabase
    try await database.modifyRecords(saving: records, deleting: [])
}
```

### Conflict Resolution

Current implementation: **Last-Write-Wins**

```swift
func resolveConflict(local: TimerSettings, remote: TimerSettings) -> TimerSettings {
    // Compare timestamps
    if local.lastModified > remote.lastModified {
        return local
    } else {
        return remote
    }
}
```

### Error Handling

```swift
enum CloudSyncError: Error {
    case notAvailable
    case networkUnavailable
    case accountNotSignedIn
    case quotaExceeded
    case unknownError(Error)
}

func handleSyncError(_ error: Error) {
    if let ckError = error as? CKError {
        switch ckError.code {
        case .networkUnavailable:
            print("Network unavailable")
        case .notAuthenticated:
            print("Not signed in to iCloud")
        case .quotaExceeded:
            print("iCloud storage full")
        default:
            print("CloudKit error: \(ckError)")
        }
    }
}
```

### Testing iCloud

**On Simulator**
```bash
1. Sign in to iCloud in Simulator Settings
2. Enable iCloud Drive
3. Run app and enable sync
4. Tap "Sync Now" to test
```

**On Device**
```bash
1. Sign in to iCloud in iOS Settings
2. Install app via Xcode or TestFlight
3. Enable sync in app Settings
4. Verify Last Sync timestamp updates
```

**Multi-Device Testing**
```bash
1. Same Apple ID on both devices
2. Enable sync on both devices
3. Complete session on Device A
4. Tap "Sync Now" on Device A
5. Open app on Device B (triggers auto-sync)
6. Verify session appears in stats
```

### CloudKit Dashboard

Access at: https://icloud.developer.apple.com

**Useful Features:**
- Schema Editor: View/edit record types
- Data Browser: Inspect records (development only)
- Logs: Debug sync issues
- Analytics: Usage metrics

---

## Focus Mode Integration

### Technical Implementation

#### FocusModeManager

```swift
class FocusModeManager: ObservableObject {
    @Published var focusModeEnabled: Bool = false
    @Published var syncWithFocus: Bool = false
    
    func suggestFocusMode() {
        guard focusModeEnabled, syncWithFocus else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Enable Focus Mode?"
        content.body = "Swipe down from top-right and tap Focus for distraction-free work."
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "focus-mode-suggestion",
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}
```

#### Integration Points

**Session Start**
```swift
func startTimer() {
    // ... start timer logic
    
    if currentSessionType == .focus {
        focusModeManager.suggestFocusMode()
    }
}
```

**Settings**
```swift
Toggle("Enable Focus Mode", isOn: $focusModeEnabled)
Toggle("Sync with iOS Focus", isOn: $syncWithFocus)
    .disabled(!focusModeEnabled)
```

### iOS Version Compatibility

```swift
@available(iOS 16.1, *)
func setupFocusMode() {
    // Focus Mode specific code
}

// Graceful fallback
if #available(iOS 16.1, *) {
    setupFocusMode()
} else {
    // Hide Focus Mode settings
}
```

### Best Practices

- ✅ Never auto-control Focus Mode
- ✅ Provide clear user instructions
- ✅ Make it opt-in only
- ✅ Handle iOS version compatibility
- ✅ Respect notification permissions

---

## Background Execution

### Background Modes

Configured in `Info.plist`:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

### Timer Continuity

**Approach:** Calculate elapsed time on foreground return

```swift
class TimerManager: ObservableObject {
    @Published var remainingTime: TimeInterval = 0
    private var startTime: Date?
    private var pauseTime: Date?
    
    func startTimer() {
        startTime = Date()
        isRunning = true
    }
    
    func handleAppDidEnterBackground() {
        // Timer state preserved
        pauseTime = Date()
    }
    
    func handleAppWillEnterForeground() {
        guard let startTime = startTime, let pauseTime = pauseTime else { return }
        
        let elapsed = Date().timeIntervalSince(pauseTime)
        remainingTime -= elapsed
        
        if remainingTime <= 0 {
            completeSession()
        }
    }
}
```

### Notification Scheduling

```swift
func scheduleNotification(in timeInterval: TimeInterval) {
    let content = UNMutableNotificationContent()
    content.title = "Pomodoro Complete!"
    content.body = "Time for a break."
    content.sound = .default
    
    let trigger = UNTimeIntervalNotificationTrigger(
        timeInterval: timeInterval,
        repeats: false
    )
    
    let request = UNNotificationRequest(
        identifier: "timer-complete",
        content: content,
        trigger: trigger
    )
    
    UNUserNotificationCenter.current().add(request)
}
```

### Background Tasks

Register background task:
```swift
func registerBackgroundTasks() {
    BGTaskScheduler.shared.register(
        forTaskWithIdentifier: "com.pomodorotimer.sync",
        using: nil
    ) { task in
        self.handleBackgroundSync(task: task as! BGAppRefreshTask)
    }
}

func handleBackgroundSync(task: BGAppRefreshTask) {
    task.expirationHandler = {
        task.setTaskCompleted(success: false)
    }
    
    // Perform sync
    CloudSyncManager.shared.syncAll { success in
        task.setTaskCompleted(success: success)
    }
}
```

---

## Performance Optimization

### Memory Management

**Avoid Retain Cycles**
```swift
class TimerManager {
    func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
}
```

**Lazy Loading**
```swift
lazy var statisticsCalculator = StatisticsCalculator()
```

**Resource Cleanup**
```swift
deinit {
    timer?.invalidate()
    timer = nil
}
```

### UI Performance

**Debouncing**
```swift
@Published var searchText: String = "" {
    didSet {
        debounceSearch()
    }
}

private func debounceSearch() {
    searchTask?.cancel()
    searchTask = Task {
        try? await Task.sleep(nanoseconds: 300_000_000)
        await performSearch()
    }
}
```

**Efficient List Rendering**
```swift
List {
    ForEach(sessions) { session in
        SessionRow(session: session)
    }
}
.onAppear {
    // Load more if needed
}
```

### Data Optimization

**Batch Operations**
```swift
func saveSessions(_ sessions: [TimerSession]) {
    let records = sessions.map { createRecord(from: $0) }
    database.modifyRecords(saving: records, deleting: [])
}
```

**Caching**
```swift
private var statsCache: [String: Any] = [:]

func getStats(for date: Date) -> Stats {
    let key = dateFormatter.string(from: date)
    if let cached = statsCache[key] as? Stats {
        return cached
    }
    
    let stats = calculateStats(for: date)
    statsCache[key] = stats
    return stats
}
```

---

## Debugging & Troubleshooting

### Common Issues

**iCloud Not Available**
```swift
// Check account status
let status = try await CKContainer.default().accountStatus()
print("iCloud status: \(status)")

// Possible statuses:
// .available - Ready to use
// .noAccount - Not signed in
// .restricted - Parental controls
// .couldNotDetermine - Unknown state
```

**Timer Inaccuracy**
```swift
// Use system Timer correctly
timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
    self.updateTimer()
}

// Ensure timer is added to run loop
RunLoop.current.add(timer, forMode: .common)
```

**Memory Leaks**
```swift
// Use Instruments Memory Graph
// Profile → Instruments → Leaks
// Check for retain cycles

// Use weak/unowned references
timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
    guard let self = self else { return }
    self.updateTimer()
}
```

### Debug Logging

```swift
#if DEBUG
func debugLog(_ message: String) {
    print("[DEBUG] \(message)")
}
#else
func debugLog(_ message: String) {}
#endif

// Usage
debugLog("Timer started with duration: \(duration)")
```

### Breakpoint Tips

- Set breakpoints in `TimerManager.startTimer()`
- Use conditional breakpoints for specific states
- Log breakpoints for non-intrusive debugging
- Exception breakpoint for crash debugging

---

## CI/CD Configuration

### GitHub Actions Example

```yaml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: macos-latest
    
    steps:
      - uses: actions/checkout@v2
      
      - name: Select Xcode
        run: sudo xcode-select -s /Applications/Xcode_26.0.app
      
      - name: Run Unit Tests
        run: |
          xcodebuild test \
            -project PomodoroTimer.xcodeproj \
            -scheme PomodoroTimer \
            -destination 'platform=iOS Simulator,name=iPhone 17' \
            -only-testing:PomodoroTimerTests
      
      - name: Run Performance Tests
        run: |
          xcodebuild test \
            -project PomodoroTimer.xcodeproj \
            -scheme PomodoroTimer \
            -destination 'platform=iOS Simulator,name=iPhone 17' \
            -only-testing:PomodoroTimerPerformanceTests
      
      - name: Generate Coverage Report
        run: |
          xcrun llvm-cov export \
            -instr-profile coverage.profdata \
            -format=lcov > coverage.lcov
```

### Pre-commit Hooks

```bash
#!/bin/sh
# .git/hooks/pre-commit

echo "Running tests..."
xcodebuild test -project PomodoroTimer.xcodeproj \
  -scheme PomodoroTimer \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -only-testing:PomodoroTimerTests

if [ $? -ne 0 ]; then
  echo "Tests failed. Commit aborted."
  exit 1
fi

echo "Tests passed!"
exit 0
```

---

## Additional Resources

### Apple Documentation
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [CloudKit Documentation](https://developer.apple.com/documentation/cloudkit)
- [XCTest Framework](https://developer.apple.com/documentation/xctest)
- [App Intents](https://developer.apple.com/documentation/appintents)

### WWDC Sessions
- CloudKit Best Practices
- What's New in SwiftUI
- Testing in Xcode
- Background Execution

### Community
- [Swift Forums](https://forums.swift.org)
- [Apple Developer Forums](https://developer.apple.com/forums/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/swiftui)

---

## Contributing

When adding new features:

1. **Write tests first** (TDD approach)
2. **Ensure tests pass** before committing
3. **Update documentation** for API changes
4. **Follow code style** (SwiftLint)
5. **Add inline comments** for complex logic
6. **Update this guide** for architectural changes

---

**Last Updated:** January 26, 2026  
**Version:** 1.1.0  
**Maintainer:** Development Team

*For user-facing documentation, see USER_GUIDE.md*

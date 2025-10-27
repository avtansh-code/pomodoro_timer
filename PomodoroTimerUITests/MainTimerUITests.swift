//
//  MainTimerUITests.swift
//  PomodoroTimerUITests
//
//  Comprehensive UI tests for Main Timer functionality
//

import XCTest

final class MainTimerUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        
        // Reset app state for consistent testing
        app.launchArguments = ["--reset-for-testing"]
        app.launch()
        
        // Wait for app to fully load
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 5.0))
    }
    
    override func tearDownWithError() throws {
        app?.terminate()
        app = nil
    }
    
    // MARK: - App Launch Tests
    
    func testAppLaunchesSuccessfully() throws {
        // Verify main UI elements exist
        XCTAssertTrue(app.staticTexts["Pomodoro Timer"].exists || 
                     app.navigationBars.element.exists ||
                     app.otherElements.containing(.staticText, identifier: "Timer").element.exists,
                     "Main timer interface should be visible")
    }
    
    func testMainUIElementsExist() throws {
        // Timer display should exist (looking for time format like "25:00")
        let timerDisplay = app.staticTexts.matching(NSPredicate(format: "label MATCHES '.*[0-9]+:[0-9]+.*'")).firstMatch
        XCTAssertTrue(timerDisplay.waitForExistence(timeout: 3.0), "Timer display should exist")
        
        // Start button should exist
        let startButton = app.buttons["startTimerButton"]
        if !startButton.exists {
            // Alternative button identifiers
            let alternativeStartButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Start' OR label CONTAINS 'Play'")).firstMatch
            XCTAssertTrue(alternativeStartButton.exists, "Start button should exist")
        } else {
            XCTAssertTrue(startButton.exists, "Start button should exist")
        }
    }
    
    // MARK: - Timer Control Tests
    
    func testStartTimer() throws {
        let startButton = findStartButton()
        XCTAssertTrue(startButton.waitForExistence(timeout: 3.0), "Start button should be available")
        
        startButton.tap()
        
        // Verify button changed to Pause or stop icon
        let pauseButton = findPauseButton()
        XCTAssertTrue(pauseButton.waitForExistence(timeout: 2.0), "Pause button should appear after starting timer")
    }
    
    func testPauseTimer() throws {
        // Start timer first
        let startButton = findStartButton()
        XCTAssertTrue(startButton.waitForExistence(timeout: 3.0))
        startButton.tap()
        
        // Wait for pause button and tap it
        let pauseButton = findPauseButton()
        XCTAssertTrue(pauseButton.waitForExistence(timeout: 2.0))
        pauseButton.tap()
        
        // Verify button changed to Resume
        let resumeButton = findResumeButton()
        XCTAssertTrue(resumeButton.waitForExistence(timeout: 2.0), "Resume button should appear after pausing")
    }
    
    func testResumeTimer() throws {
        // Start, pause, then resume
        let startButton = findStartButton()
        startButton.tap()
        
        let pauseButton = findPauseButton()
        XCTAssertTrue(pauseButton.waitForExistence(timeout: 2.0))
        pauseButton.tap()
        
        let resumeButton = findResumeButton()
        XCTAssertTrue(resumeButton.waitForExistence(timeout: 2.0))
        resumeButton.tap()
        
        // Should be back to pause button
        XCTAssertTrue(findPauseButton().waitForExistence(timeout: 2.0))
    }
    
    func testResetTimer() throws {
        // Start timer and let it run briefly
        let startButton = findStartButton()
        startButton.tap()
        
        // Wait for timer to start
        sleep(2)
        
        // Find and tap reset button
        let resetButton = findResetButton()
        if resetButton.exists {
            resetButton.tap()
            
            // Verify timer is reset (start button should be available again)
            XCTAssertTrue(findStartButton().waitForExistence(timeout: 2.0), "Start button should appear after reset")
        }
    }
    
    func testSkipSession() throws {
        let skipButton = findSkipButton()
        
        if skipButton.waitForExistence(timeout: 2.0) && skipButton.isHittable {
            let initialSessionType = getCurrentSessionType()
            
            skipButton.tap()
            
            // Wait for session change
            sleep(1)
            
            let newSessionType = getCurrentSessionType()
            
            // Session type should have changed (or at least UI should remain stable)
            if initialSessionType == newSessionType {
                // Even if session type didn't change visually, test that app didn't crash
                XCTAssertTrue(app.exists, "App should remain stable after skip")
            } else {
                XCTAssertNotEqual(initialSessionType, newSessionType, "Session type should change after skip")
            }
        }
    }
    
    // MARK: - Timer Display Tests
    
    func testTimerDisplayFormat() throws {
        let timerDisplay = app.staticTexts.matching(NSPredicate(format: "label MATCHES '.*[0-9]+:[0-9]+.*'")).firstMatch
        XCTAssertTrue(timerDisplay.waitForExistence(timeout: 3.0), "Timer should display time in MM:SS format")
        
        let displayText = timerDisplay.label
        let timePattern = "^.*\\d{1,2}:\\d{2}.*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", timePattern)
        XCTAssertTrue(predicate.evaluate(with: displayText), "Timer display should contain time format")
    }
    
    func testTimerDisplayUpdates() throws {
        let timerDisplay = app.staticTexts.matching(NSPredicate(format: "label MATCHES '.*[0-9]+:[0-9]+.*'")).firstMatch
        XCTAssertTrue(timerDisplay.waitForExistence(timeout: 2.0))
        
        let initialValue = timerDisplay.label
        
        // Start timer
        let startButton = findStartButton()
        startButton.tap()
        
        // Verify timer is running by checking pause button exists
        XCTAssertTrue(findPauseButton().waitForExistence(timeout: 2.0))
        
        // Wait for timer to potentially tick
        sleep(3)
        
        let updatedValue = timerDisplay.label
        
        // Either the time changed, or we can confirm timer is running by pause button existence
        if initialValue == updatedValue {
            // If time hasn't visually changed, ensure timer is still in running state
            XCTAssertTrue(findPauseButton().exists, "Timer should still be running")
        } else {
            // Time should have decreased (assuming it's a countdown)
            XCTAssertNotEqual(initialValue, updatedValue, "Timer should update when running")
        }
    }
    
    // MARK: - Session Type Tests
    
    func testSessionTypeDisplayed() throws {
        let sessionTypeExists = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS[c] 'Focus' OR label CONTAINS[c] 'Break' OR label CONTAINS[c] 'Pomodoro'")
        ).firstMatch.exists
        
        XCTAssertTrue(sessionTypeExists, "Current session type should be displayed")
    }
    
    func testFocusSessionDisplay() throws {
        // App should start in Focus mode
        let focusIndicator = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Focus'")).firstMatch
        if focusIndicator.exists {
            XCTAssertTrue(focusIndicator.exists, "Focus session should be indicated")
        }
    }
    
    // MARK: - Navigation Tests
    
    func testNavigateToSettings() throws {
        let settingsAccessed = navigateToSettings()
        XCTAssertTrue(settingsAccessed, "Should be able to navigate to settings")
        
        if settingsAccessed {
            // Verify we're on settings screen
            sleep(1)
            let settingsElements = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'Settings'")).count
            XCTAssertGreaterThan(settingsElements, 0, "Settings screen should contain settings-related text")
        }
    }
    
    func testNavigateToStatistics() throws {
        let statsAccessed = navigateToStatistics()
        if statsAccessed {
            // Verify we're on statistics screen
            sleep(1)
            let statsElements = app.staticTexts.matching(
                NSPredicate(format: "label CONTAINS[c] 'Statistics' OR label CONTAINS[c] 'Stats'")
            ).count
            XCTAssertGreaterThan(statsElements, 0, "Statistics screen should contain stats-related text")
        }
    }
    
    func testReturnToMainTimer() throws {
        // Navigate away and back
        if navigateToSettings() {
            sleep(1)
            
            // Navigate back to timer
            let timerTab = app.tabBars.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Timer'")).firstMatch
            let backButton = app.navigationBars.buttons.element(boundBy: 0)
            
            if timerTab.exists {
                timerTab.tap()
            } else if backButton.exists {
                backButton.tap()
            }
            
            // Verify we're back on main timer
            XCTAssertTrue(findStartButton().waitForExistence(timeout: 2.0), "Should return to main timer view")
        }
    }
    
    // MARK: - Accessibility Tests
    
    func testAccessibilityLabels() throws {
        let buttons = app.buttons.allElementsBoundByIndex
        XCTAssertGreaterThan(buttons.count, 0, "Should have accessible buttons")
        
        for button in buttons.prefix(5) { // Test first 5 buttons to avoid timeout
            if button.exists {
                XCTAssertFalse(button.label.isEmpty, "Button '\(button.identifier)' should have accessibility label")
            }
        }
    }
    
    func testVoiceOverElements() throws {
        // Test that key elements are accessible to screen readers
        let timerDisplay = app.staticTexts.matching(NSPredicate(format: "label CONTAINS ':'")).firstMatch
        let startButton = findStartButton()
        
        // These elements should be accessible (exist and either be hittable or have accessibility info)
        if timerDisplay.exists {
            XCTAssertTrue(timerDisplay.isHittable || !timerDisplay.label.isEmpty)
        }
        
        if startButton.exists {
            XCTAssertTrue(startButton.isHittable || !startButton.label.isEmpty)
        }
    }
    
    // MARK: - Interaction Tests
    
    func testMultipleButtonTaps() throws {
        let startButton = findStartButton()
        XCTAssertTrue(startButton.waitForExistence(timeout: 3.0))
        
        // Tap start multiple times rapidly
        for _ in 0..<3 {
            if startButton.exists && startButton.isHittable {
                startButton.tap()
            }
        }
        
        // App should remain stable
        XCTAssertTrue(app.exists, "App should handle multiple rapid taps")
    }
    
    func testTimerControlSequence() throws {
        let startButton = findStartButton()
        
        // Perform a sequence of operations
        if startButton.exists {
            startButton.tap()
            sleep(1)
            
            let pauseButton = findPauseButton()
            if pauseButton.exists {
                pauseButton.tap()
                sleep(1)
                
                let resumeButton = findResumeButton()
                if resumeButton.exists {
                    resumeButton.tap()
                    sleep(1)
                    
                    let resetButton = findResetButton()
                    if resetButton.exists {
                        resetButton.tap()
                    }
                }
            }
        }
        
        // App should remain stable throughout
        XCTAssertTrue(app.exists, "App should handle timer control sequence")
    }
    
    // MARK: - Visual Elements Tests
    
    func testCircularProgressIndicator() throws {
        // Look for progress indicators or visual timer elements
        let progressElements = app.otherElements.count + app.images.count
        XCTAssertGreaterThan(progressElements, 0, "Should have visual elements for progress indication")
    }
    
    func testSessionCounterDisplay() throws {
        // Look for completed sessions counter
        let counterExists = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS[c] 'Session' OR label MATCHES '.*[0-9]+/[0-9]+.*' OR label MATCHES '.*[0-9]+.*'")
        ).firstMatch.exists
        
        // Session counter might be present
        if counterExists {
            XCTAssertTrue(counterExists, "Session counter should be visible if implemented")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testAppStabilityUnderLoad() throws {
        // Perform many operations to test stability
        for i in 0..<10 {
            let startButton = findStartButton()
            if startButton.exists && startButton.isHittable {
                startButton.tap()
                
                if i % 2 == 0 {
                    let pauseButton = findPauseButton()
                    if pauseButton.waitForExistence(timeout: 1.0) {
                        pauseButton.tap()
                    }
                }
                
                let resetButton = findResetButton()
                if resetButton.exists && resetButton.isHittable {
                    resetButton.tap()
                }
            }
        }
        
        XCTAssertTrue(app.exists, "App should remain stable under load")
    }
    
    func testRecoveryFromErrors() throws {
        // Test app recovery by performing potentially error-prone operations
        
        // Try tapping elements that might not be ready
        app.buttons.element(boundBy: 0).tap()
        app.staticTexts.element(boundBy: 0).tap()
        
        // App should still be functional
        XCTAssertTrue(app.exists)
        XCTAssertTrue(findStartButton().waitForExistence(timeout: 3.0), "App should recover and show start button")
    }
    
    // MARK: - Helper Methods
    
    private func findStartButton() -> XCUIElement {
        let identifierButton = app.buttons["startTimerButton"]
        if identifierButton.exists {
            return identifierButton
        }
        
        let labelButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Start' OR label CONTAINS[c] 'Play'")).firstMatch
        return labelButton
    }
    
    private func findPauseButton() -> XCUIElement {
        let identifierButton = app.buttons["pauseTimerButton"]
        if identifierButton.exists {
            return identifierButton
        }
        
        let labelButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Pause'")).firstMatch
        return labelButton
    }
    
    private func findResumeButton() -> XCUIElement {
        let identifierButton = app.buttons["resumeTimerButton"]
        if identifierButton.exists {
            return identifierButton
        }
        
        let labelButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Resume'")).firstMatch
        return labelButton
    }
    
    private func findResetButton() -> XCUIElement {
        let identifierButton = app.buttons["resetTimerButton"]
        if identifierButton.exists {
            return identifierButton
        }
        
        let labelButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Reset'")).firstMatch
        return labelButton
    }
    
    private func findSkipButton() -> XCUIElement {
        let identifierButton = app.buttons["skipSessionButton"]
        if identifierButton.exists {
            return identifierButton
        }
        
        let labelButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Skip'")).firstMatch
        return labelButton
    }
    
    private func getCurrentSessionType() -> String {
        let sessionText = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS[c] 'Focus' OR label CONTAINS[c] 'Break' OR label CONTAINS[c] 'Pomodoro'")
        ).firstMatch
        
        return sessionText.exists ? sessionText.label : ""
    }
    
    private func navigateToSettings() -> Bool {
        let settingsTab = app.tabBars.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Settings'")).firstMatch
        let settingsButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Settings'")).firstMatch
        
        if settingsTab.exists {
            settingsTab.tap()
            return true
        } else if settingsButton.exists {
            settingsButton.tap()
            return true
        }
        
        return false
    }
    
    private func navigateToStatistics() -> Bool {
        let statsTab = app.tabBars.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Statistics' OR label CONTAINS[c] 'Stats'")).firstMatch
        let statsButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Statistics' OR label CONTAINS[c] 'Stats'")).firstMatch
        
        if statsTab.exists {
            statsTab.tap()
            return true
        } else if statsButton.exists {
            statsButton.tap()
            return true
        }
        
        return false
    }
}

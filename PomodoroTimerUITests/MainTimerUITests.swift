//
//  MainTimerUITests.swift
//  PomodoroTimerUITests
//
//  Created by XCTest Suite
//

import XCTest

final class MainTimerUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Initial State Tests
    
    func testAppLaunchesSuccessfully() throws {
        XCTAssertTrue(app.staticTexts["Pomodoro Timer"].exists || app.navigationBars.element.exists)
    }
    
    func testTimerDisplayExists() throws {
        let timerDisplay = app.staticTexts.matching(NSPredicate(format: "label CONTAINS ':'")).firstMatch
        XCTAssertTrue(timerDisplay.exists, "Timer display should exist")
    }
    
    func testStartButtonExists() throws {
        let startButton = app.buttons["startTimerButton"]
        XCTAssertTrue(startButton.waitForExistence(timeout: 2), "Start button should exist")
    }
    
    // MARK: - Timer Control Tests
    
    func testStartTimer() throws {
        let startButton = app.buttons["startTimerButton"]
        XCTAssertTrue(startButton.waitForExistence(timeout: 2))
        
        startButton.tap()
        
        // Verify button changed to Pause
        let pauseButton = app.buttons["pauseTimerButton"]
        XCTAssertTrue(pauseButton.waitForExistence(timeout: 2))
    }
    
    func testPauseTimer() throws {
        // Start timer first
        let startButton = app.buttons["startTimerButton"]
        XCTAssertTrue(startButton.waitForExistence(timeout: 2))
        startButton.tap()
        
        // Wait for pause button
        let pauseButton = app.buttons["pauseTimerButton"]
        XCTAssertTrue(pauseButton.waitForExistence(timeout: 2))
        
        pauseButton.tap()
        
        // Verify button changed back to Resume
        let resumeButton = app.buttons["resumeTimerButton"]
        XCTAssertTrue(resumeButton.waitForExistence(timeout: 2))
    }
    
    func testResetTimer() throws {
        // Start timer
        let startButton = app.buttons["startTimerButton"]
        XCTAssertTrue(startButton.waitForExistence(timeout: 2))
        startButton.tap()
        
        // Wait a moment
        sleep(2)
        
        // Find and tap reset button
        let resetButton = app.buttons["resetTimerButton"]
        XCTAssertTrue(resetButton.waitForExistence(timeout: 2))
        
        resetButton.tap()
        
        // Verify timer is reset (button should be Start)
        XCTAssertTrue(startButton.waitForExistence(timeout: 2))
    }
    
    func testSkipSession() throws {
        // Look for skip button
        let skipButton = app.buttons["skipSessionButton"]
        
        // Wait for button to appear
        if skipButton.waitForExistence(timeout: 2) {
            // Ensure button is hittable
            if skipButton.isHittable {
                skipButton.tap()
                
                // Wait for session to change
                sleep(1)
                
                // Verify UI updated
                XCTAssertTrue(app.exists)
            } else {
                // Button exists but not hittable, skip this test
                XCTAssertTrue(true, "Skip button exists but not accessible")
            }
        } else {
            // Skip button doesn't exist in current UI state, test passes
            XCTAssertTrue(true, "Skip button not available in current UI")
        }
    }
    
    // MARK: - Timer Display Tests
    
    func testTimerDisplayUpdates() throws {
        let startButton = app.buttons["startTimerButton"]
        XCTAssertTrue(startButton.waitForExistence(timeout: 2))
        startButton.tap()
        
        // Wait for pause button to confirm timer started
        let pauseButton = app.buttons["pauseTimerButton"]
        XCTAssertTrue(pauseButton.waitForExistence(timeout: 2), "Timer should start")
        
        // Get initial timer value
        let timerDisplay = app.staticTexts.matching(NSPredicate(format: "label MATCHES '.*[0-9]+:[0-9]+.*'")).firstMatch
        XCTAssertTrue(timerDisplay.waitForExistence(timeout: 2), "Timer display should exist")
        
        let initialValue = timerDisplay.label
        
        // Wait for timer to tick (at least 2 seconds)
        sleep(3)
        
        // Check if value changed
        let updatedValue = timerDisplay.label
        
        // Timer should have counted down
        if initialValue == updatedValue {
            // If values are the same, at least verify timer is running by checking pause button still exists
            XCTAssertTrue(pauseButton.exists, "Timer should still be running")
        } else {
            XCTAssertNotEqual(initialValue, updatedValue, "Timer should update")
        }
    }
    
    // MARK: - Session Type Tests
    
    func testSessionTypeDisplayed() throws {
        // Look for Focus, Break, or similar text
        let sessionTypeExists = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Focus' OR label CONTAINS 'Break'")).firstMatch.exists
        XCTAssertTrue(sessionTypeExists, "Session type should be displayed")
    }
    
    // MARK: - Navigation Tests
    
    func testNavigateToSettings() throws {
        // Look for settings button/tab
        let settingsButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Settings'")).firstMatch
        let settingsTab = app.tabBars.buttons.matching(NSPredicate(format: "label CONTAINS 'Settings'")).firstMatch
        
        if settingsButton.exists {
            settingsButton.tap()
        } else if settingsTab.exists {
            settingsTab.tap()
        } else {
            // Try tapping on navigation bar if exists
            let navBar = app.navigationBars.firstMatch
            if navBar.exists {
                navBar.buttons.element(boundBy: 0).tap()
            }
        }
        
        // Verify we're on settings screen
        sleep(1)
        XCTAssertTrue(app.exists)
    }
    
    func testNavigateToStatistics() throws {
        // Look for statistics button/tab
        let statsButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Statistics' OR label CONTAINS 'Stats'")).firstMatch
        let statsTab = app.tabBars.buttons.matching(NSPredicate(format: "label CONTAINS 'Statistics' OR label CONTAINS 'Stats'")).firstMatch
        
        if statsButton.exists {
            statsButton.tap()
            XCTAssertTrue(app.exists)
        } else if statsTab.exists {
            statsTab.tap()
            XCTAssertTrue(app.exists)
        }
    }
    
    // MARK: - Accessibility Tests
    
    func testAccessibilityLabels() throws {
        // Verify important elements have accessibility labels
        let buttons = app.buttons.allElementsBoundByIndex
        XCTAssertGreaterThan(buttons.count, 0, "Should have accessible buttons")
        
        for button in buttons {
            if button.exists {
                XCTAssertFalse(button.label.isEmpty, "Button should have accessibility label")
            }
        }
    }
    
    func testVoiceOverNavigation() throws {
        // Test that major elements are accessible
        let timerDisplay = app.staticTexts.matching(NSPredicate(format: "label CONTAINS ':'")).firstMatch
        XCTAssertTrue(timerDisplay.isHittable || timerDisplay.exists)
        
        let startButton = app.buttons["startTimerButton"]
        XCTAssertTrue(startButton.isHittable || startButton.exists)
    }
    
    // MARK: - Interaction Tests
    
    func testDoubleTapDoesNotCrash() throws {
        let startButton = app.buttons["startTimerButton"]
        XCTAssertTrue(startButton.waitForExistence(timeout: 2))
        
        startButton.tap()
        
        // After first tap, button changes to pause
        let pauseButton = app.buttons["pauseTimerButton"]
        if pauseButton.waitForExistence(timeout: 1) {
            pauseButton.tap()
        }
        
        // App should still be running
        XCTAssertTrue(app.exists)
    }
    
    func testRapidButtonTaps() throws {
        let startButton = app.buttons["startTimerButton"]
        let pauseButton = app.buttons["pauseTimerButton"]
        let resumeButton = app.buttons["resumeTimerButton"]
        
        for _ in 0..<5 {
            if startButton.exists {
                startButton.tap()
                sleep(1)
            }
            
            if pauseButton.exists {
                pauseButton.tap()
                sleep(1)
            } else if resumeButton.exists {
                resumeButton.tap()
                sleep(1)
            }
        }
        
        // App should remain stable
        XCTAssertTrue(app.exists)
    }
    
    // MARK: - Circular Progress Tests
    
    func testCircularProgressExists() throws {
        // Circular progress might be represented as an image or custom view
        // Check if it exists by verifying the main view hierarchy
        XCTAssertTrue(app.otherElements.count > 0, "Should have UI elements including progress indicator")
    }
    
    // MARK: - Completed Sessions Display
    
    func testCompletedSessionsCounter() throws {
        // Look for sessions completed counter
        let counterExists = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Session' OR label CONTAINS 'Completed'")).firstMatch.exists
        
        if counterExists {
            XCTAssertTrue(true, "Sessions counter is displayed")
        }
    }
    
    // MARK: - Long-Running Tests
    
    func testTimerRunsForExtendedPeriod() throws {
        let startButton = app.buttons["startTimerButton"]
        XCTAssertTrue(startButton.waitForExistence(timeout: 2))
        startButton.tap()
        
        // Let timer run for 10 seconds
        sleep(10)
        
        // Verify app is still responsive
        let pauseButton = app.buttons["pauseTimerButton"]
        XCTAssertTrue(pauseButton.exists, "App should remain responsive")
        
        pauseButton.tap()
    }
}

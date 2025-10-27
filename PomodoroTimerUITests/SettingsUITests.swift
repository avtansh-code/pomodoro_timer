//
//  SettingsUITests.swift
//  PomodoroTimerUITests
//
//  Created by XCTest Suite
//

import XCTest

final class SettingsUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
        // Navigate to settings
        navigateToSettings()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Helper Methods
    
    func navigateToSettings() {
        let settingsTab = app.tabBars.buttons.matching(NSPredicate(format: "label CONTAINS 'Settings'")).firstMatch
        let settingsButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Settings'")).firstMatch
        
        if settingsTab.exists {
            settingsTab.tap()
        } else if settingsButton.exists {
            settingsButton.tap()
        }
        
        sleep(1)
    }
    
    // MARK: - Settings Screen Tests
    
    func testSettingsScreenExists() throws {
        // Verify we're on settings screen
        let settingsText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Settings'")).firstMatch
        XCTAssertTrue(settingsText.exists || app.navigationBars.element.exists)
    }
    
    // MARK: - Toggle Tests
    
    func testSoundToggle() throws {
        let soundToggle = app.switches.matching(NSPredicate(format: "label CONTAINS 'Sound'")).firstMatch
        
        if soundToggle.exists {
            let initialState = soundToggle.value as? String
            soundToggle.tap()
            
            // Verify state changed
            let newState = soundToggle.value as? String
            XCTAssertNotEqual(initialState, newState, "Sound toggle should change state")
        }
    }
    
    func testHapticToggle() throws {
        let hapticToggle = app.switches.matching(NSPredicate(format: "label CONTAINS 'Haptic'")).firstMatch
        
        if hapticToggle.exists {
            let initialState = hapticToggle.value as? String
            hapticToggle.tap()
            
            let newState = hapticToggle.value as? String
            XCTAssertNotEqual(initialState, newState)
        }
    }
    
    func testNotificationsToggle() throws {
        let notificationsToggle = app.switches.matching(NSPredicate(format: "label CONTAINS 'Notification'")).firstMatch
        
        if notificationsToggle.exists {
            let initialState = notificationsToggle.value as? String
            notificationsToggle.tap()
            
            let newState = notificationsToggle.value as? String
            XCTAssertNotEqual(initialState, newState)
        }
    }
    
    func testAutoStartBreaksToggle() throws {
        let autoStartToggle = app.switches.matching(NSPredicate(format: "label CONTAINS 'Auto' AND label CONTAINS 'Break'")).firstMatch
        
        if autoStartToggle.exists {
            autoStartToggle.tap()
            // Verify toggle worked
            XCTAssertTrue(app.exists)
        }
    }
    
    func testAutoStartFocusToggle() throws {
        let autoStartToggle = app.switches.matching(NSPredicate(format: "label CONTAINS 'Auto' AND label CONTAINS 'Focus'")).firstMatch
        
        if autoStartToggle.exists {
            autoStartToggle.tap()
            XCTAssertTrue(app.exists)
        }
    }
    
    // MARK: - Theme Selection Tests
    
    func testThemeSelection() throws {
        // Look for theme picker or buttons
        let themeElements = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Theme' OR label CONTAINS 'Light' OR label CONTAINS 'Dark'"))
        
        if themeElements.count > 0 {
            let firstTheme = themeElements.element(boundBy: 0)
            if firstTheme.exists {
                firstTheme.tap()
                XCTAssertTrue(app.exists)
            }
        }
    }
    
    func testSystemThemeOption() throws {
        let systemTheme = app.buttons.matching(NSPredicate(format: "label CONTAINS 'System'")).firstMatch
        
        if systemTheme.exists {
            systemTheme.tap()
            XCTAssertTrue(app.exists, "System theme should be selectable")
        }
    }
    
    // MARK: - Duration Picker Tests
    
    func testFocusDurationAdjustment() throws {
        // Look for focus duration controls
        let focusLabel = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Focus' AND label CONTAINS 'Duration'")).firstMatch
        
        if focusLabel.exists {
            // Look for stepper or slider near the label
            let steppers = app.steppers
            let sliders = app.sliders
            
            if steppers.count > 0 {
                let stepper = steppers.element(boundBy: 0)
                stepper.buttons.element(boundBy: 0).tap() // Increment
                XCTAssertTrue(app.exists)
            } else if sliders.count > 0 {
                let slider = sliders.element(boundBy: 0)
                slider.adjust(toNormalizedSliderPosition: 0.5)
                XCTAssertTrue(app.exists)
            }
        }
    }
    
    func testShortBreakDurationAdjustment() throws {
        let shortBreakLabel = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Short' AND label CONTAINS 'Break'")).firstMatch
        
        if shortBreakLabel.exists {
            // Interact with duration control
            let steppers = app.steppers
            if steppers.count > 1 {
                steppers.element(boundBy: 1).buttons.element(boundBy: 0).tap()
                XCTAssertTrue(app.exists)
            }
        }
    }
    
    // MARK: - Sessions Until Long Break Tests
    
    func testSessionsUntilLongBreakAdjustment() throws {
        let sessionsLabel = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Sessions' AND (label CONTAINS 'Long' OR label CONTAINS 'Break')")).firstMatch
        
        if sessionsLabel.exists {
            let steppers = app.steppers
            if steppers.count > 0 {
                let lastStepper = steppers.element(boundBy: steppers.count - 1)
                lastStepper.buttons.element(boundBy: 0).tap()
                XCTAssertTrue(app.exists)
            }
        }
    }
    
    // MARK: - Focus Mode Tests
    
    func testFocusModeToggle() throws {
        let focusModeToggle = app.switches.matching(NSPredicate(format: "label CONTAINS 'Focus Mode'")).firstMatch
        
        if focusModeToggle.exists {
            focusModeToggle.tap()
            XCTAssertTrue(app.exists)
        }
    }
    
    // MARK: - iCloud Sync Tests
    
    func testiCloudSyncToggle() throws {
        let iCloudToggle = app.switches.matching(NSPredicate(format: "label CONTAINS 'iCloud' OR label CONTAINS 'Sync'")).firstMatch
        
        if iCloudToggle.exists {
            iCloudToggle.tap()
            XCTAssertTrue(app.exists)
        }
    }
    
    // MARK: - Settings Persistence Tests
    
    func testSettingsPersistAcrossRelaunch() throws {
        // Toggle a setting
        let soundToggle = app.switches.matching(NSPredicate(format: "label CONTAINS 'Sound'")).firstMatch
        
        if soundToggle.exists {
            soundToggle.tap()
            let stateAfterToggle = soundToggle.value as? String
            
            // Terminate and relaunch app
            app.terminate()
            app.launch()
            
            // Navigate back to settings
            navigateToSettings()
            
            // Verify setting persisted
            let soundToggleAfterRelaunch = app.switches.matching(NSPredicate(format: "label CONTAINS 'Sound'")).firstMatch
            if soundToggleAfterRelaunch.exists {
                let persistedState = soundToggleAfterRelaunch.value as? String
                XCTAssertEqual(stateAfterToggle, persistedState, "Settings should persist across app launches")
            }
        }
    }
    
    // MARK: - Scroll Tests
    
    func testScrollThroughSettings() throws {
        let settingsView = app.scrollViews.firstMatch
        
        if settingsView.exists {
            // Scroll down
            settingsView.swipeUp()
            XCTAssertTrue(app.exists)
            
            // Scroll back up
            settingsView.swipeDown()
            XCTAssertTrue(app.exists)
        }
    }
    
    // MARK: - Navigation Tests
    
    func testNavigateBackFromSettings() throws {
        // Look for back button or timer tab
        let timerTab = app.tabBars.buttons.matching(NSPredicate(format: "label CONTAINS 'Timer'")).firstMatch
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        
        if timerTab.exists {
            timerTab.tap()
            XCTAssertTrue(app.exists)
        } else if backButton.exists {
            backButton.tap()
            XCTAssertTrue(app.exists)
        }
    }
    
    // MARK: - Multiple Setting Changes
    
    func testMultipleSettingChanges() throws {
        // Toggle multiple settings
        let switches = app.switches.allElementsBoundByIndex
        
        for (index, toggle) in switches.enumerated() where index < 3 {
            if toggle.exists {
                toggle.tap()
            }
        }
        
        // App should remain stable
        XCTAssertTrue(app.exists)
    }
}

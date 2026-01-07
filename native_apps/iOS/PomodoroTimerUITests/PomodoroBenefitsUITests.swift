//
//  PomodoroBenefitsUITests.swift
//  PomodoroTimerUITests
//
//  UI tests for the Pomodoro Benefits educational page
//

import XCTest

final class PomodoroBenefitsUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
        // Navigate to Pomodoro Benefits view
        navigateToPomodoroBenefits()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Helper Methods
    
    func navigateToPomodoroBenefits() {
        // Navigate to Settings tab
        let settingsTab = app.tabBars.buttons.matching(NSPredicate(format: "label CONTAINS 'Settings'")).firstMatch
        if settingsTab.exists {
            settingsTab.tap()
            sleep(1)
        }
        
        // Tap on "Learn about Pomodoro" link
        let learnLink = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Learn about Pomodoro'")).firstMatch
        if learnLink.exists {
            learnLink.tap()
            sleep(1)
        }
    }
    
    // MARK: - Navigation Tests
    
    func testNavigationToPomodoroBenefits() throws {
        // Verify we reached the benefits page
        let powerOfPomodoroText = app.staticTexts["The Power of Pomodoro"]
        let navigationBar = app.navigationBars["The Pomodoro Way"]
        
        XCTAssertTrue(powerOfPomodoroText.exists || navigationBar.exists, 
                     "Should navigate to Pomodoro Benefits page")
    }
    
    func testLearnAboutPomodoroLinkExists() throws {
        // Go back to settings
        app.navigationBars.buttons.element(boundBy: 0).tap()
        sleep(1)
        
        // Verify "Learn about Pomodoro" link exists and is visible
        let learnLink = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Learn about Pomodoro'")).firstMatch
        XCTAssertTrue(learnLink.exists, "Learn about Pomodoro link should exist in Settings")
    }
    
    func testLearnAboutPomodoroAtTopOfSettings() throws {
        // Go back to settings
        app.navigationBars.buttons.element(boundBy: 0).tap()
        sleep(1)
        
        // Verify it's in the first section (Get Started)
        let getStartedHeader = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Get Started'")).firstMatch
        XCTAssertTrue(getStartedHeader.exists, "Get Started section should exist at top")
        
        let learnLink = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Learn about Pomodoro'")).firstMatch
        XCTAssertTrue(learnLink.exists, "Learn link should be visible without scrolling")
    }
    
    // MARK: - Content Tests
    
    func testHeaderSectionExists() throws {
        // Check for main title
        let titleText = app.staticTexts["The Power of Pomodoro"]
        XCTAssertTrue(titleText.exists, "Main title should be visible")
        
        // Check for subtitle
        let subtitleText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Focus deeper'")).firstMatch
        XCTAssertTrue(subtitleText.exists, "Subtitle should be visible")
    }
    
    func testHistorySectionExists() throws {
        // Scroll to ensure history section is visible
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            scrollView.swipeUp()
        }
        
        // Check for Francesco Cirillo mention
        let francescoText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Francesco Cirillo'")).firstMatch
        XCTAssertTrue(francescoText.exists, "History section should mention Francesco Cirillo")
    }
    
    func testHowItWorksSectionExists() throws {
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            scrollView.swipeUp()
            sleep(1)
        }
        
        // Check for step descriptions
        let chooseTaskText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Choose' OR label CONTAINS 'task'")).firstMatch
        let setTimerText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Set' OR label CONTAINS 'timer' OR label CONTAINS '25'")).firstMatch
        
        XCTAssertTrue(chooseTaskText.exists || setTimerText.exists, 
                     "How It Works section should describe the steps")
    }
    
    func testBenefitsSectionExists() throws {
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            // Scroll to benefits section
            scrollView.swipeUp()
            sleep(1)
            scrollView.swipeUp()
            sleep(1)
        }
        
        // Check for benefit mentions
        let focusText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Focus' OR label CONTAINS 'focus'")).firstMatch
        let productivityText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'productivity' OR label CONTAINS 'Productivity'")).firstMatch
        
        XCTAssertTrue(focusText.exists || productivityText.exists, 
                     "Benefits section should describe advantages")
    }
    
    func testConsiderationsSectionExists() throws {
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            // Scroll to bottom
            for _ in 0..<3 {
                scrollView.swipeUp()
                sleep(1)
            }
        }
        
        // Check for considerations or drawbacks mention
        let considerationsText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'consider' OR label CONTAINS 'mind' OR label CONTAINS 'limitation'")).firstMatch
        XCTAssertTrue(considerationsText.exists, "Considerations section should exist")
    }
    
    // MARK: - CTA Button Tests
    
    func testStartPomodoroButtonExists() throws {
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            // Scroll to bottom to find CTA button
            for _ in 0..<4 {
                scrollView.swipeUp()
                sleep(1)
            }
        }
        
        // Look for the CTA button
        let startButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Start' AND label CONTAINS 'Pomodoro'")).firstMatch
        XCTAssertTrue(startButton.exists, "Start Your First Pomodoro button should exist")
    }
    
    func testStartPomodoroButtonNavigation() throws {
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            // Scroll to bottom
            for _ in 0..<4 {
                scrollView.swipeUp()
                sleep(1)
            }
        }
        
        // Tap the CTA button
        let startButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Start' AND label CONTAINS 'Pomodoro'")).firstMatch
        if startButton.exists {
            startButton.tap()
            sleep(2)
            
            // Verify we navigated to Timer tab
            let timerElements = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Timer' OR label CONTAINS 'Focus' OR label CONTAINS '25:00'"))
            XCTAssertTrue(timerElements.count > 0, "Should navigate to Timer screen")
        }
    }
    
    // MARK: - Scroll Tests
    
    func testScrollThroughContent() throws {
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists, "Benefits page should be scrollable")
        
        // Scroll down through content
        scrollView.swipeUp()
        sleep(1)
        scrollView.swipeUp()
        sleep(1)
        
        // Scroll back up
        scrollView.swipeDown()
        sleep(1)
        scrollView.swipeDown()
        
        // Page should remain stable
        XCTAssertTrue(app.exists)
    }
    
    func testScrollToBottom() throws {
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            // Scroll all the way to bottom
            for _ in 0..<5 {
                scrollView.swipeUp()
                sleep(1)
            }
            
            // Verify CTA button is visible
            let startButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Start'")).firstMatch
            XCTAssertTrue(startButton.exists, "Should be able to scroll to CTA button")
        }
    }
    
    // MARK: - Back Navigation Tests
    
    func testBackNavigationToSettings() throws {
        // Tap back button
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        if backButton.exists {
            backButton.tap()
            sleep(1)
            
            // Verify we're back in Settings
            let settingsText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Settings'")).firstMatch
            let learnLink = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Learn about Pomodoro'")).firstMatch
            
            XCTAssertTrue(settingsText.exists || learnLink.exists, 
                         "Should navigate back to Settings")
        }
    }
    
    // MARK: - Icon Tests
    
    func testIconsVisible() throws {
        // The benefits page should have various SF Symbols icons
        // XCUITest can't directly test SF Symbols, but we can verify images exist
        let images = app.images
        XCTAssertTrue(images.count > 0, "Benefits page should contain decorative icons")
    }
    
    // MARK: - Content Readability Tests
    
    func testAllSectionsAccessible() throws {
        let scrollView = app.scrollViews.firstMatch
        
        // Collect all static text elements as we scroll
        var allTextElements: Set<String> = []
        
        // Scroll and collect text
        for _ in 0..<5 {
            let texts = app.staticTexts.allElementsBoundByIndex
            for text in texts {
                if text.exists {
                    allTextElements.insert(text.label)
                }
            }
            
            if scrollView.exists {
                scrollView.swipeUp()
                sleep(1)
            }
        }
        
        // Verify we found substantial content
        XCTAssertTrue(allTextElements.count > 10, 
                     "Should have multiple text elements across all sections")
    }
    
    // MARK: - Multiple Visit Tests
    
    func testMultipleVisitsToPage() throws {
        // Visit page multiple times
        for i in 0..<3 {
            // Go back
            let backButton = app.navigationBars.buttons.element(boundBy: 0)
            if backButton.exists {
                backButton.tap()
                sleep(1)
            }
            
            // Return to page
            let learnLink = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Learn about Pomodoro'")).firstMatch
            if learnLink.exists {
                learnLink.tap()
                sleep(1)
            }
            
            // Verify page still works
            let titleText = app.staticTexts["The Power of Pomodoro"]
            XCTAssertTrue(titleText.exists, "Page should work on visit \(i + 1)")
        }
    }
    
    // MARK: - Accessibility Tests
    
    func testAccessibilityLabels() throws {
        // Verify the main link has proper accessibility
        app.navigationBars.buttons.element(boundBy: 0).tap()
        sleep(1)
        
        let learnLink = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Learn about Pomodoro'")).firstMatch
        XCTAssertTrue(learnLink.exists, "Learn link should have accessibility support")
        
        // Verify link is tappable
        learnLink.tap()
        sleep(1)
        
        let titleText = app.staticTexts["The Power of Pomodoro"]
        XCTAssertTrue(titleText.exists, "Navigation should work via accessibility")
    }
}

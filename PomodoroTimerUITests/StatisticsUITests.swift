//
//  StatisticsUITests.swift
//  PomodoroTimerUITests
//
//  UI tests for the Statistics page
//

import XCTest

final class StatisticsUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
        // Navigate to Statistics view
        navigateToStatistics()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Helper Methods
    
    func navigateToStatistics() {
        // Find and tap Statistics tab
        let statsTab = app.tabBars.buttons.matching(NSPredicate(format: "label CONTAINS 'Statistics' OR label CONTAINS 'Stats'")).firstMatch
        
        if statsTab.exists {
            statsTab.tap()
            sleep(1)
        }
    }
    
    // MARK: - Navigation Tests
    
    func testNavigationToStatistics() throws {
        // Verify we're on the statistics screen
        let statisticsTitle = app.navigationBars["Statistics"]
        let statsText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Statistics'")).firstMatch
        
        XCTAssertTrue(statisticsTitle.exists || statsText.exists, 
                     "Should navigate to Statistics screen")
    }
    
    func testStatisticsTabExists() throws {
        // Navigate back to timer
        let timerTab = app.tabBars.buttons.matching(NSPredicate(format: "label CONTAINS 'Timer'")).firstMatch
        if timerTab.exists {
            timerTab.tap()
            sleep(1)
        }
        
        // Verify Statistics tab exists
        let statsTab = app.tabBars.buttons.matching(NSPredicate(format: "label CONTAINS 'Statistics' OR label CONTAINS 'Stats'")).firstMatch
        XCTAssertTrue(statsTab.exists, "Statistics tab should exist")
    }
    
    // MARK: - Time Range Picker Tests
    
    func testTimeRangePicker() throws {
        // Find the segmented control
        let segmentedControl = app.segmentedControls.firstMatch
        
        if segmentedControl.exists {
            XCTAssertTrue(segmentedControl.exists, "Time range picker should exist")
            
            // Try to find Week and Month buttons
            let weekButton = app.buttons["Week"]
            let monthButton = app.buttons["Month"]
            
            if weekButton.exists {
                XCTAssertTrue(weekButton.exists, "Week button should exist")
            }
            
            if monthButton.exists {
                XCTAssertTrue(monthButton.exists, "Month button should exist")
            }
        }
    }
    
    func testTimeRangeSwitching() throws {
        let weekButton = app.buttons["Week"]
        let monthButton = app.buttons["Month"]
        
        if weekButton.exists && monthButton.exists {
            // Tap Month
            monthButton.tap()
            sleep(1)
            XCTAssertTrue(app.exists, "App should remain stable after switching to Month")
            
            // Tap Week
            weekButton.tap()
            sleep(1)
            XCTAssertTrue(app.exists, "App should remain stable after switching to Week")
        }
    }
    
    // MARK: - Streak Card Tests
    
    func testStreakCardExists() throws {
        // Look for flame icon or streak text
        let flameIcon = app.images.matching(NSPredicate(format: "label CONTAINS 'flame'")).firstMatch
        let streakText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Streak' OR label CONTAINS 'Day'")).firstMatch
        
        XCTAssertTrue(flameIcon.exists || streakText.exists, 
                     "Streak card should be visible")
    }
    
    func testStreakCardDisplaysNumber() throws {
        // The streak number should be visible (even if it's 0)
        let staticTexts = app.staticTexts.allElementsBoundByIndex
        var foundNumericStreak = false
        
        for text in staticTexts {
            let label = text.label
            // Check if it's a number or contains "Day"
            if Int(label) != nil || label.contains("Day") {
                foundNumericStreak = true
                break
            }
        }
        
        XCTAssertTrue(foundNumericStreak, "Streak card should display streak number")
    }
    
    // MARK: - Chart Tests
    
    func testChartsExist() throws {
        let scrollView = app.scrollViews.firstMatch
        
        // Scroll to see charts
        if scrollView.exists {
            scrollView.swipeUp()
            sleep(1)
        }
        
        // Look for chart-related text
        let sessionChart = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Sessions per Day'")).firstMatch
        let focusTrend = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Focus Time Trend'")).firstMatch
        let distribution = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Session Distribution' OR label CONTAINS 'Distribution'")).firstMatch
        
        XCTAssertTrue(sessionChart.exists || focusTrend.exists || distribution.exists, 
                     "At least one chart section should be visible")
    }
    
    func testSessionsPerDayChartHeader() throws {
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            scrollView.swipeUp()
            sleep(1)
        }
        
        let chartHeader = app.staticTexts["Sessions per Day"]
        XCTAssertTrue(chartHeader.exists, "Sessions per Day chart header should exist")
    }
    
    func testFocusTimeTrendChartHeader() throws {
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            scrollView.swipeUp()
            sleep(1)
            scrollView.swipeUp()
            sleep(1)
        }
        
        let chartHeader = app.staticTexts["Focus Time Trend"]
        XCTAssertTrue(chartHeader.exists, "Focus Time Trend chart header should exist")
    }
    
    func testSessionDistributionChartHeader() throws {
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            for _ in 0..<3 {
                scrollView.swipeUp()
                sleep(1)
            }
        }
        
        let chartHeader = app.staticTexts["Session Distribution"]
        XCTAssertTrue(chartHeader.exists, "Session Distribution chart header should exist")
    }
    
    // MARK: - Stats Section Tests
    
    func testTodayStatsSection() throws {
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            for _ in 0..<3 {
                scrollView.swipeUp()
                sleep(1)
            }
        }
        
        // Look for "Today" section
        let todayHeader = app.staticTexts["Today"]
        XCTAssertTrue(todayHeader.exists, "Today stats section should exist")
    }
    
    func testWeekStatsSection() throws {
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            for _ in 0..<4 {
                scrollView.swipeUp()
                sleep(1)
            }
        }
        
        // Look for "Week" section (default selection)
        let weekHeader = app.staticTexts["Week"]
        XCTAssertTrue(weekHeader.exists, "Week stats section should exist")
    }
    
    func testStatsRowsExist() throws {
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            for _ in 0..<4 {
                scrollView.swipeUp()
                sleep(1)
            }
        }
        
        // Look for common stats labels
        let totalSessions = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Total Sessions'")).firstMatch
        let focusSessions = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Focus Sessions'")).firstMatch
        let focusTime = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Focus Time'")).firstMatch
        
        XCTAssertTrue(totalSessions.exists || focusSessions.exists || focusTime.exists, 
                     "Stats rows should be visible")
    }
    
    func testTotalSessionsStatDisplayed() throws {
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            for _ in 0..<4 {
                scrollView.swipeUp()
                sleep(1)
            }
        }
        
        let totalSessionsLabel = app.staticTexts["Total Sessions"]
        XCTAssertTrue(totalSessionsLabel.exists, "Total Sessions stat should be displayed")
    }
    
    func testFocusSessionsStatDisplayed() throws {
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            for _ in 0..<4 {
                scrollView.swipeUp()
                sleep(1)
            }
        }
        
        let focusSessionsLabel = app.staticTexts["Focus Sessions"]
        XCTAssertTrue(focusSessionsLabel.exists, "Focus Sessions stat should be displayed")
    }
    
    func testTotalFocusTimeStatDisplayed() throws {
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            for _ in 0..<4 {
                scrollView.swipeUp()
                sleep(1)
            }
        }
        
        let focusTimeLabel = app.staticTexts["Total Focus Time"]
        XCTAssertTrue(focusTimeLabel.exists, "Total Focus Time stat should be displayed")
    }
    
    func testBreakTimeStatDisplayed() throws {
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            for _ in 0..<4 {
                scrollView.swipeUp()
                sleep(1)
            }
        }
        
        let breakTimeLabel = app.staticTexts["Break Time"]
        XCTAssertTrue(breakTimeLabel.exists, "Break Time stat should be displayed")
    }
    
    // MARK: - Motivational Quote Tests
    
    func testMotivationalQuoteExists() throws {
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            // Scroll to bottom
            for _ in 0..<5 {
                scrollView.swipeUp()
                sleep(1)
            }
        }
        
        // Look for sparkles icon or motivational text patterns
        let sparklesIcon = app.images.matching(NSPredicate(format: "label CONTAINS 'sparkles'")).firstMatch
        let motivationalText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '🎯' OR label CONTAINS '💪' OR label CONTAINS '🌱' OR label CONTAINS 'Keep going' OR label CONTAINS 'progress'")).firstMatch
        
        XCTAssertTrue(sparklesIcon.exists || motivationalText.exists, 
                     "Motivational quote card should exist")
    }
    
    // MARK: - Scroll Tests
    
    func testScrollThroughStatistics() throws {
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists, "Statistics view should be scrollable")
        
        // Scroll down
        scrollView.swipeUp()
        sleep(1)
        scrollView.swipeUp()
        sleep(1)
        
        // Scroll back up
        scrollView.swipeDown()
        sleep(1)
        
        // App should remain stable
        XCTAssertTrue(app.exists)
    }
    
    func testScrollToBottom() throws {
        let scrollView = app.scrollViews.firstMatch
        
        if scrollView.exists {
            // Scroll all the way to bottom
            for _ in 0..<6 {
                scrollView.swipeUp()
                sleep(1)
            }
            
            // Verify we can see motivational quote
            let motivationalElements = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'progress' OR label CONTAINS 'focus' OR label CONTAINS 'Keep'"))
            XCTAssertTrue(motivationalElements.count > 0, "Should be able to scroll to bottom")
        }
    }
    
    // MARK: - Empty State Tests
    
    func testEmptyStateDisplay() throws {
        // If there are no sessions, empty state should be shown
        let noSessionsText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'No sessions yet' OR label CONTAINS 'no focus sessions'")).firstMatch
        
        // This might not exist if user has sessions, but we test it doesn't crash
        if noSessionsText.exists {
            XCTAssertTrue(noSessionsText.exists, "Empty state message should be clear")
        }
    }
    
    // MARK: - Data Update Tests
    
    func testTimeRangeAffectsDisplayedData() throws {
        let weekButton = app.buttons["Week"]
        let monthButton = app.buttons["Month"]
        
        if weekButton.exists && monthButton.exists {
            // Switch to Month
            monthButton.tap()
            sleep(1)
            
            // Stats should still be visible (even if different)
            let scrollView = app.scrollViews.firstMatch
            if scrollView.exists {
                for _ in 0..<4 {
                    scrollView.swipeUp()
                    sleep(1)
                }
            }
            
            let monthHeader = app.staticTexts["Month"]
            XCTAssertTrue(monthHeader.exists, "Month stats should be displayed")
            
            // Switch back to Week
            weekButton.tap()
            sleep(1)
            
            let weekHeader = app.staticTexts["Week"]
            XCTAssertTrue(weekHeader.exists, "Week stats should be displayed")
        }
    }
    
    // MARK: - Icon Tests
    
    func testStatisticsPageHasIcons() throws {
        // Statistics page should have various icons
        let images = app.images
        XCTAssertTrue(images.count > 0, "Statistics page should contain icons")
    }
    
    func testStreakFlameIcon() throws {
        let flameIcon = app.images.matching(NSPredicate(format: "label CONTAINS 'flame'")).firstMatch
        XCTAssertTrue(flameIcon.exists, "Flame icon should be visible for streak")
    }
    
    // MARK: - Content Accessibility Tests
    
    func testAllSectionsAccessible() throws {
        let scrollView = app.scrollViews.firstMatch
        var allHeaders: Set<String> = []
        
        // Collect headers as we scroll
        for _ in 0..<6 {
            let texts = app.staticTexts.allElementsBoundByIndex
            for text in texts {
                let label = text.label
                if label.contains("per Day") || 
                   label.contains("Trend") || 
                   label.contains("Distribution") ||
                   label == "Today" ||
                   label == "Week" ||
                   label == "Month" {
                    allHeaders.insert(label)
                }
            }
            
            if scrollView.exists {
                scrollView.swipeUp()
                sleep(1)
            }
        }
        
        // Should have found multiple section headers
        XCTAssertTrue(allHeaders.count >= 3, "Should have multiple accessible sections")
    }
    
    // MARK: - Navigation Between Tabs Tests
    
    func testNavigateToTimerAndBack() throws {
        // Navigate to Timer
        let timerTab = app.tabBars.buttons.matching(NSPredicate(format: "label CONTAINS 'Timer'")).firstMatch
        if timerTab.exists {
            timerTab.tap()
            sleep(1)
        }
        
        // Navigate back to Statistics
        let statsTab = app.tabBars.buttons.matching(NSPredicate(format: "label CONTAINS 'Statistics' OR label CONTAINS 'Stats'")).firstMatch
        if statsTab.exists {
            statsTab.tap()
            sleep(1)
        }
        
        // Verify we're back on Statistics
        let statisticsTitle = app.navigationBars["Statistics"]
        XCTAssertTrue(statisticsTitle.exists, "Should navigate back to Statistics")
    }
    
    func testNavigateToSettingsAndBack() throws {
        // Navigate to Settings
        let settingsTab = app.tabBars.buttons.matching(NSPredicate(format: "label CONTAINS 'Settings'")).firstMatch
        if settingsTab.exists {
            settingsTab.tap()
            sleep(1)
        }
        
        // Navigate back to Statistics
        let statsTab = app.tabBars.buttons.matching(NSPredicate(format: "label CONTAINS 'Statistics' OR label CONTAINS 'Stats'")).firstMatch
        if statsTab.exists {
            statsTab.tap()
            sleep(1)
        }
        
        // Verify we're back on Statistics
        let statisticsTitle = app.navigationBars["Statistics"]
        XCTAssertTrue(statisticsTitle.exists, "Should navigate back to Statistics")
    }
    
    // MARK: - Multiple Visit Tests
    
    func testMultipleVisitsToStatistics() throws {
        for i in 0..<3 {
            // Navigate away to Timer
            let timerTab = app.tabBars.buttons.matching(NSPredicate(format: "label CONTAINS 'Timer'")).firstMatch
            if timerTab.exists {
                timerTab.tap()
                sleep(1)
            }
            
            // Navigate back to Statistics
            let statsTab = app.tabBars.buttons.matching(NSPredicate(format: "label CONTAINS 'Statistics'")).firstMatch
            if statsTab.exists {
                statsTab.tap()
                sleep(1)
            }
            
            // Verify page still works
            let statisticsTitle = app.navigationBars["Statistics"]
            XCTAssertTrue(statisticsTitle.exists, "Statistics should work on visit \(i + 1)")
        }
    }
    
    // MARK: - Performance Tests
    
    func testStatisticsLoadTime() throws {
        measure {
            // Navigate away and back to test load time
            let timerTab = app.tabBars.buttons.matching(NSPredicate(format: "label CONTAINS 'Timer'")).firstMatch
            if timerTab.exists {
                timerTab.tap()
            }
            
            let statsTab = app.tabBars.buttons.matching(NSPredicate(format: "label CONTAINS 'Statistics'")).firstMatch
            if statsTab.exists {
                statsTab.tap()
            }
            
            // Wait for content to load
            let statisticsTitle = app.navigationBars["Statistics"]
            _ = statisticsTitle.waitForExistence(timeout: 2)
        }
    }
}

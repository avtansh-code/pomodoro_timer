//
//  XCTestCase+Extensions.swift
//  PomodoroTimerTests
//
//  Created by XCTest Suite
//

import XCTest
import Combine
@testable import PomodoroTimer

extension XCTestCase {
    /// Wait for a condition to be met with a timeout
    func wait(for condition: @escaping () -> Bool, timeout: TimeInterval = 5.0, description: String = "Condition not met") {
        let expectation = self.expectation(description: description)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if condition() {
                expectation.fulfill()
                timer.invalidate()
            }
        }
        
        waitForExpectations(timeout: timeout) { error in
            timer.invalidate()
            if error != nil {
                XCTFail("Timeout waiting for: \(description)")
            }
        }
    }
    
    /// Wait for timer state to change
    func waitForTimerState(_ timerManager: TimerManager, expectedState: TimerState, timeout: TimeInterval = 5.0) {
        wait(for: { 
            MainActor.assumeIsolated { 
                timerManager.timerState == expectedState 
            }
        }, timeout: timeout, description: "Timer state to be \(expectedState)")
    }
    
    /// Wait for a published value to change
    func waitForPublishedValue<T: Equatable>(
        _ publisher: Published<T>.Publisher,
        expectedValue: T,
        timeout: TimeInterval = 5.0,
        description: String = "Published value to change"
    ) {
        let expectation = self.expectation(description: description)
        var cancellable: AnyCancellable?
        
        cancellable = publisher
            .sink { value in
                if value == expectedValue {
                    expectation.fulfill()
                    cancellable?.cancel()
                }
            }
        
        waitForExpectations(timeout: timeout) { error in
            cancellable?.cancel()
            if error != nil {
                XCTFail("Timeout waiting for: \(description)")
            }
        }
    }
    
    /// Create a mock timer manager with short durations for testing
    @MainActor
    func createMockTimerManager() -> TimerManager {
        let settings = TimerSettingsFactory.createShortDurationSettings()
        return TimerManager(settings: settings)
    }
    
    /// Verify notification was scheduled
    func verifyNotificationScheduled(identifier: String? = nil, completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            if let identifier = identifier {
                completion(requests.contains { $0.identifier == identifier })
            } else {
                completion(!requests.isEmpty)
            }
        }
    }
    
    /// Clear all notifications
    func clearAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    /// Create test expectation with timeout
    func expectation(timeout: TimeInterval = 5.0, description: String = "Test expectation") -> XCTestExpectation {
        let exp = self.expectation(description: description)
        return exp
    }
    
    /// Wait for async operation
    func waitForAsync(timeout: TimeInterval = 5.0, operation: @escaping (@escaping () -> Void) -> Void) {
        let expectation = self.expectation(description: "Async operation")
        
        operation {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout)
    }
}

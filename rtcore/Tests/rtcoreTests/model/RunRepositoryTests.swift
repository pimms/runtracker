import XCTest
import HealthKit
@testable import rtcore

final class RunRepositoryTests : XCTestCase {
    func testFetchCallsCompletionHandler() {
        let healthStore = HKHealthStore()
        let repo = RunRepository(healthStore: healthStore)

        let expectations = expectation(description: "Should load an empty set of workouts")

        repo.loadRuns {
            XCTAssertEqual(0, repo.runSummaries.count)
            expectations.fulfill()
        }

        waitForExpectations(timeout: 0.5)
    }
}

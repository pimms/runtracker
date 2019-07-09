import Foundation
import HealthKit

struct MockRunSummary : RunSummary {
    let date: Date
    let distance: Double
}

class MockRunRepository : RunRepository {
    var mockSummaries: [RunSummary]

    init(workouts: [RunSummary]) {
        self.mockSummaries = workouts
        super.init(healthStore: HKHealthStore())
        runSummaries = mockSummaries
        didChange.send()
    }

    convenience init() {
        self.init(workouts: [])
    }

    override func refresh() {
        runSummaries = mockSummaries
        didChange.send()
    }
}

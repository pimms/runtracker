import Foundation

struct MockRunSummary : RunSummary {
    let date: Date
    let distance: Double
}

class MockRunRepository : RunRepositoryProtocol {
    var runSummaries: [RunSummary]

    init(workouts: [RunSummary]) {
        self.runSummaries = workouts
    }

    convenience init() {
        self.init(workouts: [])
    }

    func loadRuns(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            completion()
        }
    }
}

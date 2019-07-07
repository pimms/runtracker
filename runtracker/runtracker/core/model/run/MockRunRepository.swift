import Foundation

struct MockRunSummary : RunSummary {
    let date: Date
    let distance: Double
}

class MockRunRepository : RunRepositoryProtocol {
    var runSummaries: [RunSummary]

    private let dispatchQueue = DispatchQueue(label: "mockRunRepository dispatch queue", qos: .background)

    init(workouts: [RunSummary]) {
        self.runSummaries = workouts
    }

    convenience init() {
        self.init(workouts: [])
    }

    func loadRuns(completion: @escaping () -> Void) {
        dispatchQueue.async {
            completion()
        }
    }
}

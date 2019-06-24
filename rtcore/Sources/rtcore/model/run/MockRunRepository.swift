import Foundation

public struct MockRunSummary : RunSummary {
    public let date: Date
    public let distance: Double

    public init(date: Date, distance: Double) {
        self.date = date
        self.distance = distance
    }
}

public class MockRunRepository : RunRepositoryProtocol {
    public var runSummaries: [RunSummary] = []

    private let dispatchQueue = DispatchQueue(label: "mockRunRepository dispatch queue", qos: .background)

    public init() {}

    public init(workouts: [RunSummary]) {
        self.runSummaries = workouts
    }

    public func loadRuns(completion: @escaping () -> Void) {
        dispatchQueue.async {
            completion()
        }
    }
}

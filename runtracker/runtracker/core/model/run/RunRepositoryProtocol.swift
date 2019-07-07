import Foundation

protocol RunRepositoryProtocol {
    var runSummaries: [RunSummary] { get }

    /// Note: `completion` will get called on the main thread.
    func loadRuns(completion: @escaping () -> Void)
}

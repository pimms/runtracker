import Foundation

protocol RunRepositoryProtocol {
    var runSummaries: [RunSummary] { get }

    /// Note: `completion` will get called from the same thread as `loadRuns` was called from.
    func loadRuns(completion: @escaping () -> Void)
}

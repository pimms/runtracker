import Foundation

protocol RunRepositoryProtocol {
    var runSummaries: [RunSummary] { get }

    func refresh()
}

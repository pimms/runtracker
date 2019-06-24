import Combine
import SwiftUI

public class RunPublisher: BindableObject {
    public var didChange = CurrentValueSubject<[RunSummary], Never>([])

    public var runs: [RunSummary] = [] {
        didSet {
            didChange.send(runs)
        }
    }

    private let runRepository: RunRepositoryProtocol

    public init(runRepository: RunRepositoryProtocol) {
        self.runRepository = runRepository
        refresh()
    }

    public func refresh() {
        runRepository.loadRuns { [weak self] in
            guard let self = self else { return }
            self.runs = self.runRepository.runSummaries
        }
    }
}

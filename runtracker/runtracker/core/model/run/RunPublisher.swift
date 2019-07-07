import Combine
import SwiftUI

class RunPublisher: BindableObject {
    var didChange = CurrentValueSubject<[RunSummary], Never>([])

    public var runs: [RunSummary] = [] {
        didSet {
            didChange.send(runs)
        }
    }

    private let runRepository: RunRepositoryProtocol

    init(runRepository: RunRepositoryProtocol) {
        self.runRepository = runRepository
        refresh()
    }

    func refresh() {
        runRepository.loadRuns { [weak self] in
            guard let self = self else { return }
            self.runs = self.runRepository.runSummaries
        }
    }
}

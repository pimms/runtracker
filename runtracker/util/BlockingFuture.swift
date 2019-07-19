import Foundation

class BlockingFuture<Output> {
    private let mutex = PThreadMutex()
    private var completed = false
    private var output: Output?

    var result: Output {
        mutex.unbalancedLock()
        guard let output = output else {
            fatalError("BlockingFuture internal inconsistency — no 'output' defined")
        }
        return output
    }

    init(execute work: @escaping (@escaping (Output) -> Void) -> Void) {
        mutex.unbalancedLock()

        DispatchQueue.global(qos: .background).async {
            work({ [weak self] output in
                self?.completion(output: output)
            })
        }
    }

    private func completion(output: Output) {
        guard !completed else {
            fatalError("BlockingFuture can only be completed once")
        }

        completed = true
        self.output = output
        mutex.unbalancedUnlock()
    }
}

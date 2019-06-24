import UIKit
import Combine

class TestPublisher: Publisher {
    let subject = CurrentValueSubject<Int, Never>(15)

    func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Never, S.Input == Int {
        subject.send(15)
    }

    typealias Output = Int
    typealias Failure = Never
}

let publisher = TestPublisher()

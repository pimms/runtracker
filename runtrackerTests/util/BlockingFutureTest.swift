import XCTest
@testable import runtracker

class BlockingFutureTest: XCTestCase {
    func testSimpleProvide() {
        let future = BlockingFuture<Int> { completion in
            usleep(500_000)
            completion(15)
        }

        XCTAssertEqual(15, future.result)
    }

    func testMultipleReceive() {
        var futures = [BlockingFuture<Int>]()

        for i in 0..<10 {
            futures.append(BlockingFuture<Int> { completion in
                completion(i)
            })
        }

        for i in 0..<10 {
            XCTAssertEqual(i, futures[i].result)
        }
    }

    func testReceiveOnDifferentThread() {
        let dispatchQueue = DispatchQueue(label: "TestQueue")

        let future = BlockingFuture<Int> { completion in
            completion(13)
        }

        let expectation = self.expectation(description: "receiving async")
        var fetchedValue: Int = 0

        dispatchQueue.async {
            fetchedValue = future.result
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(13, fetchedValue)
    }
}

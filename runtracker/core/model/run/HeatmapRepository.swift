import Foundation
import HealthKit
import SwiftUI
import Combine
import CoreLocation

class HeatmapRepository : BindableObject {
    var willChange = PassthroughSubject<Void, Never>()

    private let healthStore: HKHealthStore
    private(set) var locations = [CLLocation]()

    init(healthStore: HKHealthStore, subject: PassthroughSubject<[HKWorkout], Never>) {
        self.healthStore = healthStore

        let _ = subject
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] workouts in
                guard let self = self else { return }

                // happy debugging, motherfucker
                var futureFutures = [BlockingFuture<[BlockingFuture<[CLLocation]>]>]()
                for workout in workouts {
                    let future = self.queryForRoute(inWorkout: workout)
                    futureFutures.append(future)
                }

                var locations = [CLLocation]()
                for futureFuture in futureFutures {
                    for future in futureFuture.result {
                        locations.append(contentsOf: future.result)
                    }
                }

                self.locations = locations

                DispatchQueue.main.async {
                    print("[HeatmapRepository] Fetched \(self.locations.count) locations")
                    self.willChange.send()
                }
            }
    }

    /// lol
    private func queryForRoute(inWorkout workout: HKWorkout) -> BlockingFuture<[BlockingFuture<[CLLocation]>]> {
        let future = BlockingFuture<[BlockingFuture<[CLLocation]>]> { [weak self] completion in
            guard let self = self else {
                completion([])
                return
            }

            let runningObjectQuery = HKQuery.predicateForObjects(from: workout)
            let sampleQuery = HKSampleQuery(sampleType: HKSeriesType.workoutRoute(),
                                           predicate: runningObjectQuery,
                                           limit: HKObjectQueryNoLimit,
                                           sortDescriptors: nil) { [weak self] (query, samples, error) in
                guard let self = self, let samples = samples else {
                    completion([])
                    return
                }

                var futures = [BlockingFuture<[CLLocation]>]()
                for sample in samples {
                    guard let routeSample = sample as? HKWorkoutRoute else { continue }
                    futures.append(self.queryRoute(forRouteSample: routeSample))
                }

                completion(futures)
            }

            self.healthStore.execute(sampleQuery)
        }

        return future
    }

    private func queryRoute(forRouteSample routeSample: HKWorkoutRoute) -> BlockingFuture<[CLLocation]> {
        let future = BlockingFuture<[CLLocation]> { completion in
            var locations = [CLLocation]()
            let routeQuery = HKWorkoutRouteQuery(route: routeSample) { _, loc, done, error in
                guard error == nil else {
                    completion([])
                    return
                }

                if let loc = loc {
                    locations.append(contentsOf: loc)
                }

                if done {
                    completion(locations)
                }
            }
            self.healthStore.execute(routeQuery)
        }

        return future
    }
}

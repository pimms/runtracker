import Foundation
import HealthKit
import SwiftUI
import Combine

open class RunRepository : RunRepositoryProtocol, BindableObject {
    public let didChange = PassthroughSubject<Void, Never>()

    var runSummaries: [RunSummary] = []
    
    private let healthStore: HKHealthStore

    init(healthStore: HKHealthStore) {
        self.healthStore = healthStore
    }

    // MARK: - Querying

    func refresh() {
        loadRuns { [weak self] runs in
            DispatchQueue.main.async { [weak self] in
                self?.runSummaries = runs
                self?.didChange.send()
            }
        }
    }

    private func loadRuns(completion: @escaping ([RunSummary]) -> Void) {
        let toRead = Set(arrayLiteral: HKWorkoutType.workoutType())

        healthStore.requestAuthorization(toShare: nil, read: toRead, completion: { [weak self] _, _ in
            self?.queryHealthKit { workouts in
                completion(workouts)
            }
        })
    }

    private func queryHealthKit(completion: @escaping ([HKWorkout]) -> Void) {
        let predicate = HKQuery.predicateForWorkouts(with: .running)
        let sorting = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HKSampleQuery(sampleType: HKSampleType.workoutType(),
                                  predicate: predicate,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [sorting]) { query, samples, err in
            let samples = samples ?? []
            let filtered = samples.compactMap { $0 as? HKWorkout }
            print("[WorkoutRepository] Loaded \(filtered.count) workouts")
            completion(filtered)
        }

        healthStore.execute(query)
    }
}

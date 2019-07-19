import Foundation
import HealthKit
import SwiftUI
import Combine

open class RunRepository : BindableObject {
    public let willChange = PassthroughSubject<Void, Never>()
    public let workouts = PassthroughSubject<[HKWorkout], Never>()

    // MARK: - Internal properties

    var runSummaries: [RunSummary] = [] {
        didSet {
            updateCurrentWeeksSummaries()
        }
    }

    private(set) var currentWeeksRuns: [RunSummary] = []

    // MARK: - Private properties

    private let healthStore: HKHealthStore

    init(healthStore: HKHealthStore) {
        self.healthStore = healthStore
    }

    // MARK: - Querying

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let toRead = Set(arrayLiteral: HKWorkoutType.workoutType(), HKSeriesType.workoutRoute())

        healthStore.requestAuthorization(toShare: nil, read: toRead) { success, _ in
            completion(success)
        }
    }

    func refresh() {
        queryForWorkouts { [weak self] runs in
            guard let self = self else { return }

            let diff = self.runSummaries
                .compactMap { $0 as? HKWorkout }
                .difference(from: runs) { $0 == $1 }

            if diff.count != 0 {
                self.runSummaries = runs

                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.willChange.send()
                    self.workouts.send(runs)
                }
            }
        }
    }

    private func queryForWorkouts(completion: @escaping ([HKWorkout]) -> Void) {
        let predicate = HKQuery.predicateForWorkouts(with: .running)
        let sorting = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HKSampleQuery(sampleType: HKSampleType.workoutType(),
                                  predicate: predicate,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [sorting]) { query, samples, err in
            let samples = samples ?? []
            let filtered = samples.compactMap { $0 as? HKWorkout }
            completion(filtered)
        }

        healthStore.execute(query)
    }

    // MARK: - Updating

    private func updateCurrentWeeksSummaries() {
        let weekStart = Date.today().previous(.monday, considerToday: true)
        currentWeeksRuns = runSummaries.filter { $0.date >= weekStart }
    }
}

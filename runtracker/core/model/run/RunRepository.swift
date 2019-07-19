import Foundation
import HealthKit
import SwiftUI
import Combine

open class RunRepository : BindableObject {
    public let willChange = PassthroughSubject<Void, Never>()

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
        loadRuns { [weak self] runs in
            self?.runSummaries = runs

            DispatchQueue.main.async { [weak self] in
                self?.willChange.send()
            }
        }
    }

    private func loadRuns(completion: @escaping ([RunSummary]) -> Void) {
        queryForWorkouts { [weak self] workouts in
            for workout in workouts {
                self?.queryForRoute(inWorkout: workout)
            }
            completion(workouts)
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
            print("[WorkoutRepository] Loaded \(filtered.count) workouts")
            completion(filtered)
        }

        healthStore.execute(query)
    }

    private func queryForRoute(inWorkout workout: HKWorkout) {
        let runningObjectQuery = HKQuery.predicateForObjects(from: workout)
        let routeQuery = HKSampleQuery(sampleType: HKSeriesType.workoutRoute(),
                                       predicate: runningObjectQuery,
                                       limit: HKObjectQueryNoLimit,
                                       sortDescriptors: nil) { (query, samples, error) in
            // print("Got \(samples?.count ?? 0) samples")
        }

        healthStore.execute(routeQuery)
    }

    // MARK: - Updating

    private func updateCurrentWeeksSummaries() {
        let weekStart = Date.today().previous(.monday, considerToday: true)
        currentWeeksRuns = runSummaries.filter { $0.date >= weekStart }
    }
}

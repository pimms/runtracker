import Foundation
import HealthKit

public class RunRepository : RunRepositoryProtocol {
    private(set) var runSummaries: [RunSummary] = []

    private let healthStore: HKHealthStore

    init(healthStore: HKHealthStore) {
        self.healthStore = healthStore
    }

    func loadRuns(completion: @escaping () -> Void) {
        let toRead = Set(arrayLiteral: HKWorkoutType.workoutType())

        healthStore.requestAuthorization(toShare: nil, read: toRead, completion: { [weak self] _, _ in
            self?.fetchWorkouts { [weak self] workouts in
                DispatchQueue.main.async { [weak self] in
                    self?.runSummaries = workouts
                    completion()
                }
            }
        })
    }

    private func fetchWorkouts(completion: @escaping ([HKWorkout]) -> Void) {
        let predicate = HKQuery.predicateForWorkouts(with: .running)
        let sorting = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HKSampleQuery(sampleType: HKSampleType.workoutType(), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sorting], resultsHandler: { query, samples, err in
            let samples = samples ?? []

            let cal = Calendar.current
            let currentYear = cal.component(.year, from: Date())

            let filtered = samples.compactMap { $0 as? HKWorkout }
                .filter { cal.component(.year, from: $0.endDate) == currentYear }

            print("[WorkoutRepository] Loaded \(filtered.count) workouts")
            completion(filtered)
        })

        healthStore.execute(query)
    }
}

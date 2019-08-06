import SwiftUI

struct WeeklyDistanceProgressView : View {
    @EnvironmentObject var goalRepository: WeeklyGoalRepository
    @EnvironmentObject var runRepository: RunRepository

    let weeksAgo: Int

    private var runDistances: [Double] {
        runRepository.summaries(weeksAgo: weeksAgo).map { $0.distance }
    }

    private var totalDistance: Double {
        runDistances.reduce(0, +)
    }

    private func progressText() -> String {
        let currentKm = totalDistance / 1000.0

        if let goalMeters = goalRepository.weeklyDistanceGoal?.distanceInMeters {
            let goalKm = goalMeters / 1000.0
            return "\(currentKm.string(withDecimals: 1)) km / \(goalKm.string(withDecimals: 1)) km"
        } else {
            return "\(currentKm.string(withDecimals: 1)) km"
        }
    }

    var body: some View {
        return Panel(title: "Weekly Distance") {
            VStack {
                SUIMultiSegmentProgressBar(
                    rawSegmentValues: runDistances,
                    goalValue: goalRepository.weeklyDistanceGoal?.distanceInMeters
                ).frame(height: Bar.barHeight)

                HStack {
                    Text(progressText())
                        .font(.caption)
                    Spacer()
                }
            }
        }
    }
}

#if DEBUG
import HealthKit

struct WeeklyDistanceProgressView_Previews : PreviewProvider {
    static private func run(_ distance: Double) -> MockRunSummary {
        return MockRunSummary(date: Date(), distance: distance * 1000)
    }

    static private func dgoal(_ distance: Double) -> WeeklyDistanceGoal {
        return WeeklyDistanceGoal(distanceInMeters: distance * 1000)
    }

    static var previews: some View {
        let goalRepo = WeeklyGoalRepository()
        goalRepo.weeklyDistanceGoal = WeeklyDistanceGoal(distanceInMeters: 30_000)

        let runRepo = RunRepository(healthStore: HKHealthStore())

        let list = List {
            WeeklyDistanceProgressView(weeksAgo: 0)
        }

        return VStack {
            list.colorScheme(.dark)
            list.colorScheme(.light)
        }.environmentObject(runRepo)
         .environmentObject(goalRepo)
    }
}
#endif

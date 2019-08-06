import SwiftUI

struct ProgressOverview : View {
    @EnvironmentObject var runRepository: RunRepository
    @EnvironmentObject var goalRepo: WeeklyGoalRepository

    var body: some View {
        return VStack {
            WeeklyDistanceProgressView(weeksAgo: 0)
            Spacer()
        }.padding()
    }
}

#if DEBUG
import HealthKit

struct ProgressOverview_Previews : PreviewProvider {
    static var previews: some View {
        let runRepo = RunRepository(healthStore: HKHealthStore())

        let goalRepo = WeeklyGoalRepository()
        goalRepo.weeklyDistanceGoal = WeeklyDistanceGoal(distanceInMeters: 30_000)
        goalRepo.weeklyTimeGoal = WeeklyTimeGoal(durationInMinutes: 60 * 3)

        let overview = ProgressOverview()
            .environmentObject(runRepo)
            .environmentObject(goalRepo)

        return VStack {
            List { overview }.colorScheme(.dark)
            List { overview }.colorScheme(.light)
        }
    }
}
#endif

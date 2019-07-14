import SwiftUI

struct ProgressOverview : View {
    @EnvironmentObject var runRepository: RunRepository
    @EnvironmentObject var goalRepo: WeeklyGoalRepository

    var body: some View {
        let distanceSummary = WeeklyDistanceSummaryModel(
            runs: runRepository.currentWeeksRuns,
            distanceGoal: goalRepo.weeklyDistanceGoal)

        return VStack {
            WeeklyDistanceProgressView(summary: distanceSummary)
            Spacer()
        }.padding()
    }
}

#if DEBUG
struct ProgressOverview_Previews : PreviewProvider {
    static var previews: some View {
        let runRepo = MockRunRepository(
            workouts: [
                MockRunSummary(date: Date(), distance: 10_100),
                MockRunSummary(date: Date(), distance: 3_500)
            ]
        )

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

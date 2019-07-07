import SwiftUI

struct ProgressOverview : View {
    @EnvironmentObject var runPublisher: RunPublisher
    @EnvironmentObject var goalRepo: WeeklyGoalRepository

    var body: some View {
        VStack {
            Text("Hi mom!")
        }
    }
}

#if DEBUG
struct ProgressOverview_Previews : PreviewProvider {
    static var previews: some View {
        let runRepo = MockRunRepository()
        runRepo.runSummaries = [
            MockRunSummary(date: Date(), distance: 10.1),
            MockRunSummary(date: Date(), distance: 3.5)
        ]

        let publisher = RunPublisher(runRepository: runRepo)

        let goalRepo = WeeklyGoalRepository()
        goalRepo.weeklyDistanceGoal = WeeklyDistanceGoal(distanceInMeters: 30_000)
        goalRepo.weeklyTimeGoal = WeeklyTimeGoal(durationInMinutes: 60 * 3)

        let overview = ProgressOverview()
            .environmentObject(publisher)
            .environmentObject(goalRepo)

        return VStack {
            overview.colorScheme(.dark)
            overview.colorScheme(.light)
        }
    }
}
#endif

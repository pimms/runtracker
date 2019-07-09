import SwiftUI

struct ContentView : View {
    var body: some View {
        NavigationView {
            TabbedView {
                ProgressOverview()
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Progress")
                }
            }.navigationBarTitle("Run Tracker")
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
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

        let contentView = ContentView()
            .environmentObject(runRepo)
            .environmentObject(goalRepo)

        return contentView
    }
}
#endif

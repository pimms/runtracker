import SwiftUI

struct ContentView : View {
    var body: some View {
        NavigationView {
            TabbedView {
                ProgressOverview()
                    .tag(0)
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Progress")
                    }

                SUIHeatmapView()
                    .tag(1)
                    .tabItem {
                        Image(systemName: "map.fill")
                        Text("Heatmap")
                    }

                GoalDefineView()
                    .tag(2)
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("Goals")
                    }
            }.navigationBarTitle("Run Tracker")
        }
    }
}

#if DEBUG
import HealthKit

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        let runRepo = RunRepository(healthStore: HKHealthStore())

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

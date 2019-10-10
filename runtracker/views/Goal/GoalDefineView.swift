import SwiftUI
import Combine

private class DistanceGoalProxy: ObservableObject {
    var willChange = PassthroughSubject<Void, Never>()

    var goalRepository: WeeklyGoalRepository? {
        didSet {
            if oldValue == nil, let val = goalRepository?.weeklyDistanceGoal?.distanceInMeters {
                value = val / 1000
            }
        }
    }

    var value: Double = 0 {
        didSet {
            let currentGoal = Int(goalRepository?.weeklyDistanceGoal?.distanceInMeters ?? 0)
            let newGoal = Int(value) * 1000
            if let goalRepository = goalRepository, currentGoal != newGoal {
                goalRepository.weeklyDistanceGoal = WeeklyDistanceGoal(distanceInMeters: Double(newGoal))
                willChange.send()
            }
        }
    }
}

struct GoalDefineView : View {
    private static let defaultGoal = 10.0

    @EnvironmentObject var goalRepository: WeeklyGoalRepository
    @ObservedObject private var distanceProxy = DistanceGoalProxy()

    var body: some View {
        distanceProxy.goalRepository = goalRepository
        return VStack {
            Panel(title: "Weekly Distance") {
                VStack {
                    if goalRepository.weeklyDistanceGoal == nil {
                        Text("You haven't set a weekly distance goal")
                        Button("Set a Goal", action: {
                            self.distanceProxy.value = GoalDefineView.defaultGoal
                        })
                    } else {
                        Slider(value: $distanceProxy.value, in: 0...100)

                        HStack {
                            Text("Value: \(Int($distanceProxy.value.wrappedValue))")
                            Spacer()
                        }
                    }
                }
            }
            Spacer()
        }.padding()
    }
}

#if DEBUG
struct GoalDefineView_Previews : PreviewProvider {
    static var previews: some View {
        return GoalDefineView()
            .environmentObject(WeeklyGoalRepository())
    }
}
#endif

import SwiftUI

struct WeeklySummary {
    let runs: [RunSummary]
    let distanceGoal: WeeklyDistanceGoal?
}

struct WeekOverview : View {
    private let weeklySummary: WeeklySummary

    init(weeklySummary: WeeklySummary) {
        self.weeklySummary = weeklySummary
    }

    var body: some View {
        let distances = weeklySummary.runs.map { $0.distance }
        let sum = distances.reduce(0, +)

        return Panel(title: "Weekly Progress") {
            VStack {
                SUIMultiSegmentProgressBar(
                    rawSegmentValues: distances,
                    goalValue: weeklySummary.distanceGoal?.distanceInMeters
                ).frame(height: Bar.barHeight)

                HStack {
                    Text("\(sum.string(withDecimals: 1)) / TODO")
                        .font(.caption)
                    Spacer()
                }
            }
        }
    }
}

#if DEBUG
struct WeekOverview_Previews : PreviewProvider {
    static private func run(_ distance: Double) -> MockRunSummary {
        return MockRunSummary(date: Date(), distance: distance)
    }

    static private func dgoal(_ distance: Double) -> WeeklyDistanceGoal {
        return WeeklyDistanceGoal(distanceInMeters: distance)
    }

    static var previews: some View {
        let summary1 = WeeklySummary(
            runs: [run(1), run(4)],
            distanceGoal: dgoal(2))
        let summary2 = WeeklySummary(
            runs: [run(1), run(1), run(1)],
            distanceGoal: dgoal(5))
        let summary3 = WeeklySummary(
            runs: [run(1), run(1), run(1), run(1), run(1), run(1)],
            distanceGoal: dgoal(6))

        let list = List {
            WeekOverview(weeklySummary: summary1)
            WeekOverview(weeklySummary: summary2)
            WeekOverview(weeklySummary: summary3)
        }

        return VStack {
            list.colorScheme(.dark)
            list.colorScheme(.light)
        }
    }
}
#endif

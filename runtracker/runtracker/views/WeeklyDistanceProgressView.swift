import SwiftUI

struct WeeklyDistanceSummaryModel {
    let runs: [RunSummary]
    let distanceGoal: WeeklyDistanceGoal?
}

struct WeeklyDistanceProgressView : View {
    private let summary: WeeklyDistanceSummaryModel

    private var runDistances: [Double] { summary.runs.map { $0.distance } }
    private var totalDistance: Double { runDistances.reduce(0, +) }

    init(summary: WeeklyDistanceSummaryModel) {
        self.summary = summary
    }

    private func progressText() -> String {
        let currentKm = totalDistance / 1000.0

        if let goalMeters = summary.distanceGoal?.distanceInMeters {
            let goalKm = goalMeters / 1000.0
            return "\(currentKm) km / \(goalKm) km"
        } else {
            return "\(currentKm) km"
        }
    }

    var body: some View {
        return Panel(title: "Weekly Distance") {
            VStack {
                SUIMultiSegmentProgressBar(
                    rawSegmentValues: runDistances,
                    goalValue: summary.distanceGoal?.distanceInMeters
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
struct WeeklyDistanceProgressView_Previews : PreviewProvider {
    static private func run(_ distance: Double) -> MockRunSummary {
        return MockRunSummary(date: Date(), distance: distance * 1000)
    }

    static private func dgoal(_ distance: Double) -> WeeklyDistanceGoal {
        return WeeklyDistanceGoal(distanceInMeters: distance * 1000)
    }

    static var previews: some View {
        let summary1 = WeeklyDistanceSummaryModel(
            runs: [run(1), run(4)],
            distanceGoal: dgoal(2))
        let summary2 = WeeklyDistanceSummaryModel(
            runs: [run(1), run(1), run(1)],
            distanceGoal: dgoal(5))
        let summary3 = WeeklyDistanceSummaryModel(
            runs: [run(1), run(1), run(1), run(1), run(1), run(1)],
            distanceGoal: nil)

        let list = List {
            WeeklyDistanceProgressView(summary: summary1)
            WeeklyDistanceProgressView(summary: summary2)
            WeeklyDistanceProgressView(summary: summary3)
        }

        return VStack {
            list.colorScheme(.dark)
            list.colorScheme(.light)
        }
    }
}
#endif

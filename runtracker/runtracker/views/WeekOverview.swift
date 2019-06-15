import SwiftUI

protocol WeekOverviewViewModel {
    var runDistances: [Double] { get }
    var goalDistance: Double { get }
}

struct WeekOverview : View {
    private let viewModel: WeekOverviewViewModel

    init(viewModel: WeekOverviewViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        let sum = viewModel.runDistances.reduce(0, +)

        return Panel(title: "Weekly Progress") {
            VStack {
                SUIMultiSegmentProgressBar(
                    rawSegmentValues: viewModel.runDistances,
                    goalValue: viewModel.goalDistance
                ).frame(height: Bar.barHeight)

                HStack {
                    Text("\(sum.string(withDecimals: 1)) / \(viewModel.goalDistance.string(withDecimals: 1))")
                        .font(.caption)
                    Spacer()
                }
            }
        }
    }
}

#if DEBUG
struct WeekOverview_Previews : PreviewProvider {
    private struct DemoModel: WeekOverviewViewModel {
        let runDistances: [Double]
        let goalDistance: Double
    }

    static var previews: some View {
        let model1 = DemoModel(runDistances: [20, 50], goalDistance: 30)
        let model2 = DemoModel(runDistances: [1, 1, 1], goalDistance: 5)
        let model3 = DemoModel(runDistances: [1, 1, 1, 1, 1], goalDistance: 6)

        let list = List {
            WeekOverview(viewModel: model1)
            WeekOverview(viewModel: model2)
            WeekOverview(viewModel: model3)
        }

        return VStack {
            list.colorScheme(.dark)
            list.colorScheme(.light)
        }
    }
}
#endif

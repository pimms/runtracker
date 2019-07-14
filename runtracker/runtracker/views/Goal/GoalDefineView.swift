import SwiftUI

struct GoalDefineView : View {
    @State var distance: Double = 30

    var body: some View {
        VStack {
            Panel(title: "Weekly Distance") {
                VStack {
                    Slider(value: $distance, from: 0, through: 100, by: 1)

                    HStack {
                        Text("Value: \(Int($distance.value))")
                        Spacer()
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
        GoalDefineView()
    }
}
#endif

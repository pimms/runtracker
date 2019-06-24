import SwiftUI
import rtcore

struct ProgressOverview : View {
    @EnvironmentObject var runPublisher: RunPublisher

    var body: some View {
        VStack {
            Text("Hi mom!")
        }
    }
}

#if DEBUG
struct ProgressOverview_Previews : PreviewProvider {
    static var previews: some View {
        let repo = MockRunRepository()
        repo.runSummaries = [
            MockRunSummary(date: Date(), distance: 10.1),
            MockRunSummary(date: Date(), distance: 3.5)
        ]
        let publisher = RunPublisher(runRepository: repo)

        let overview = ProgressOverview().environmentObject(publisher)

        return VStack {
            overview.colorScheme(.dark)
            overview.colorScheme(.light)
        }
    }
}
#endif

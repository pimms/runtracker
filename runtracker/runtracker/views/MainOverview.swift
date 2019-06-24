import SwiftUI
import rtcore

struct MainOverview : View {
    @EnvironmentObject var runPublisher: RunPublisher

    var body: some View {
        VStack {
            Text("Hi mom!")
        }
    }
}

#if DEBUG
struct MainOverview_Previews : PreviewProvider {
    static var previews: some View {
        let repo = MockRunRepository()
        repo.runSummaries = [
            MockRunSummary(date: Date(), distance: 10.1),
            MockRunSummary(date: Date(), distance: 3.5)
        ]
        let publisher = RunPublisher(runRepository: repo)

        let mainView = MainOverview().environmentObject(publisher)

        return VStack {
            mainView.colorScheme(.dark)
            mainView.colorScheme(.light)
        }
    }
}
#endif

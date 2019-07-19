import Foundation
import SwiftUI
import Combine
import MapKit

struct HeatmapWrapperView : UIViewRepresentable {
    // This seems to be the only way to retain the mapView when the
    // user changes tabs in the TabBar. lol.
    static let mapView = MKMapView(frame: .zero)

    func makeUIView(context: UIViewRepresentableContext<HeatmapWrapperView>) -> MKMapView {
        return HeatmapWrapperView.mapView
    }

    func updateUIView(_ mapView: MKMapView, context: UIViewRepresentableContext<HeatmapWrapperView>) {

    }
}

struct HeatmapView : View {
    @EnvironmentObject var runRepository: RunRepository

    var body: some View {
        HeatmapWrapperView()
    }
}

#if DEBUG
import HealthKit

struct HeatmapView_Preview: PreviewProvider {
    static var previews: some View {
        HeatmapView()
            .environmentObject(RunRepository(healthStore: HKHealthStore()))
    }
}
#endif

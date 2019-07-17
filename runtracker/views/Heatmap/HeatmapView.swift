import Foundation
import SwiftUI
import Combine
import MapKit

struct HeatmapView : UIViewRepresentable {
    // This seems to be the only way to retain the mapView when the
    // user changes tabs in the TabBar. lol.
    static let mapView = MKMapView(frame: .zero)

    func makeUIView(context: UIViewRepresentableContext<HeatmapView>) -> MKMapView {
        return HeatmapView.mapView
    }

    func updateUIView(_ mapView: MKMapView, context: UIViewRepresentableContext<HeatmapView>) {
        
    }
}

#if DEBUG
struct HeatmapView_Preview: PreviewProvider {
    static var previews: some View {
        HeatmapView()
    }
}
#endif

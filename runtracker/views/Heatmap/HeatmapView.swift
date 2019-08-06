import Foundation
import SwiftUI
import Combine
import MapKit
import DTMHeatmap


class HeatmapView : UIView {
    private lazy var mapView = MKMapView(frame: .zero)
    private lazy var heatMap = DTMHeatmap()

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    required init() {
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        addSubview(mapView)
        mapView.fillInSuperview()
    }

    func updateData(_ locations: [CLLocation]) {
        mapView.removeOverlay(heatMap)

        var data = [AnyHashable: Any]()
        for location in locations {
            let value = NSValue(mkMapPoint: MKMapPoint(location.coordinate))
            data[value] = 1
        }

        heatMap.setData(data)
        mapView.addOverlay(heatMap)
    }
}

private struct HeatmapWrapperView : UIViewRepresentable {
    // This seems to be the only way to retain the mapView when the
    // user changes tabs in the TabBar. lol.
    static let mapView = HeatmapView()

    @ObjectBinding var heatmapRepo: HeatmapRepository

    // updateUIView won't get called unless we add an arbitrary class prop.
    // This class and instantiation does intentionally nothing.
    // See https://gist.github.com/svanimpe/152e6539cd371a9ae0cfee42b374d7c4
    class SwiftUiIsBugged { }
    private let x = SwiftUiIsBugged()

    func makeUIView(context: UIViewRepresentableContext<HeatmapWrapperView>) -> HeatmapView {
        return HeatmapWrapperView.mapView
    }

    func updateUIView(_ mapView: HeatmapView, context: UIViewRepresentableContext<HeatmapWrapperView>) {
        mapView.updateData(heatmapRepo.locations)
    }
}

struct SUIHeatmapView: View {
    @EnvironmentObject var heatmapRepo: HeatmapRepository

    var body: some View {
        HeatmapWrapperView(heatmapRepo: heatmapRepo)
    }
}

#if DEBUG
import HealthKit

struct HeatmapView_Preview: PreviewProvider {
    static var previews: some View {
        let heatmapRepo = HeatmapRepository(healthStore: HKHealthStore(), subject: PassthroughSubject<[HKWorkout], Never>())

        return SUIHeatmapView()
            .environmentObject(heatmapRepo)
    }
}
#endif

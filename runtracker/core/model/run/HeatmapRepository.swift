import Foundation
import HealthKit
import SwiftUI
import Combine

class HeatmapRepository : BindableObject {
    var willChange = PassthroughSubject<Void, Never>()

    init(healthStore: HKHealthStore, subject: PassthroughSubject<[RunSummary], Never>) {
        
    }
}

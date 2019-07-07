import Foundation
import HealthKit

protocol RunSummary {
    var date: Date { get }

    /// The distance of the run in meters
    var distance: Double { get }
}

extension HKWorkout : RunSummary {
    var date: Date { endDate }
    var distance: Double { distanceInMeters }
}

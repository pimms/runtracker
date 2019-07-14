import Foundation
import HealthKit

public protocol RunSummary {
    var date: Date { get }

    /// The distance of the run in meters
    var distance: Double { get }
}

extension HKWorkout : RunSummary {
    public var date: Date { endDate }
    public var distance: Double { distanceInMeters }
}

#if DEBUG

struct MockRunSummary: RunSummary {
    let date: Date
    let distance: Double
}

#endif

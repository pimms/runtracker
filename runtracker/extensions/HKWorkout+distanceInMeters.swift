import HealthKit

extension HKWorkout {
    var distanceInMeters : Double {
        return totalDistance?.doubleValue(for: .meter()) ?? 0.0
    }

    var distanceInKilometers : Double {
        return distanceInMeters / 1000.0
    }
}

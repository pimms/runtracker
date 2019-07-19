import Foundation
import SwiftUI
import Combine

class WeeklyGoalRepository: BindableObject {
    var willChange = PassthroughSubject<Void, Never>()

    var weeklyDistanceGoal: WeeklyDistanceGoal? {
        didSet {
            userDefaultsDistance = weeklyDistanceGoal?.distanceInMeters ?? -1
            willChange.send()
        }
    }

    var weeklyTimeGoal: WeeklyTimeGoal? {
        didSet {
            userDefaultsTime = weeklyTimeGoal?.durationInMinutes ?? -1
            willChange.send()
        }
    }

    // MARK: - Private properties

    @UserDefault("weekly_distance_goal", defaultValue: -1)
    private var userDefaultsDistance: Double

    @UserDefault("weekly_time_goal", defaultValue: -1)
    private var userDefaultsTime: Double

    // MARK: - Methods

    init() {
        if userDefaultsDistance >= 0 {
            weeklyDistanceGoal = WeeklyDistanceGoal(distanceInMeters: userDefaultsDistance)
        }

        if userDefaultsTime >= 0 {
            weeklyTimeGoal = WeeklyTimeGoal(durationInMinutes: userDefaultsTime)
        }
    }
}

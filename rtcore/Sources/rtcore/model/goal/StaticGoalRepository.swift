import Foundation
import SQLite

public class StaticGoalRepository: GoalRepositoryProtocol {
    public var staticWeeklyDistanceGoal: WeeklyDistanceGoal = WeeklyDistanceGoal(distanceInMeters: 30_000)

    public func weeklyDistanceGoal() -> WeeklyDistanceGoal {
        return staticWeeklyDistanceGoal
    }

    public init() {}
}


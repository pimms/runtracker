import Foundation
import SwiftUI
import Combine

class WeeklyGoalRepository: BindableObject {
    var didChange = PassthroughSubject<Void, Never>()

    var weeklyDistanceGoal: WeeklyDistanceGoal? { didSet { didChange.send() } }
    var weeklyTimeGoal: WeeklyTimeGoal? { didSet { didChange.send() } }
}

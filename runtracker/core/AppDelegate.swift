import UIKit
import SwiftUI
import HealthKit

@UIApplicationMain
class AppDelegate : UIResponder {
    let weeklyGoalRepository = WeeklyGoalRepository()
    let runRepository = RunRepository(healthStore: HKHealthStore())

    override init() {
        super.init()
    }
}

extension AppDelegate : UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        runRepository.requestAuthorization(completion: { [weak self] _ in
            self?.runRepository.refresh()
        })

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) { }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
}

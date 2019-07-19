import UIKit
import SwiftUI
import HealthKit

@UIApplicationMain
class AppDelegate: UIResponder {
    var window: UIWindow?

    private let weeklyGoalRepository = WeeklyGoalRepository()
    private let runRepository = RunRepository(healthStore: HKHealthStore())

    private var initialLaunch = true
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

extension AppDelegate : UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let contentView = ContentView()
                .environmentObject(runRepository)
                .environmentObject(weeklyGoalRepository)

            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if !initialLaunch {
            runRepository.refresh()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) {
        initialLaunch = false
    }
}


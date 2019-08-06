import UIKit
import SwiftUI

class SceneDelegate : UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var runRepository: RunRepository { appDelegate.runRepository }
    private var weeklyGoalRepository: WeeklyGoalRepository { appDelegate.weeklyGoalRepository }
    private var heatmapRepository: HeatmapRepository { appDelegate.heatmapRepository }

    private var initialLaunch = true

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let contentView = ContentView()
                .environmentObject(runRepository)
                .environmentObject(weeklyGoalRepository)
                .environmentObject(heatmapRepository)

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

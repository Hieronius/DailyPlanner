import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

		guard let windowScene = (scene as? UIWindowScene) else { return }

		window = UIWindow(windowScene: windowScene)

		// MARK: RootViewController Initialization

		do {
			let dataManager = try RealmDataManager()
			let jsonHandler = JSONHandler()
			let calendarGenerator = CalendarGenerator()

			let rootVC = MainViewController(
				dataManager: dataManager,
				jsonHandler: jsonHandler,
				calendarGenerator: calendarGenerator
			)
			let NavVC = UINavigationController(rootViewController: rootVC)

			guard let window else { return }

			window.rootViewController = NavVC

			window.makeKeyAndVisible()

		} catch {
			
			print("Failed to initialize RealmDataManager", error.localizedDescription)
		}
	}

	func sceneDidDisconnect(_ scene: UIScene) {

	}

	func sceneDidBecomeActive(_ scene: UIScene) {

	}

	func sceneWillResignActive(_ scene: UIScene) {

	}

	func sceneWillEnterForeground(_ scene: UIScene) {

	}

	func sceneDidEnterBackground(_ scene: UIScene) {

	}
}


import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = ViewController()
        window.makeKeyAndVisible()
        self.window = window

        // App 启动后立即清理自身缓存
        DispatchQueue.global(qos: .userInitiated).async {
            let result = CacheCleaner.clean()

            DispatchQueue.main.async {
                (window.rootViewController as? ViewController)?
                    .showResult(result)
            }
        }

        return true
    }
}

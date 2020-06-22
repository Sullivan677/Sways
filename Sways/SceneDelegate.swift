import UIKit
import Firebase
import FirebaseAuth
import StoreKit
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    weak var handle: AuthStateDidChangeListenerHandle?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if ((user) != nil){
                let home = TabBar()
                home.selectedIndex = 1
                self?.window?.rootViewController = home
            } else {
                print("Not Logged in")
                let signup = SignUpVC()
                self?.window?.rootViewController = signup
            }
        }
        window?.overrideUserInterfaceStyle = .light
        window?.tintColor = .black
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        window?.windowScene = windowScene
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
        SKPaymentQueue.default().remove(IAPService.instance)
    }
}

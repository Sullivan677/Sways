import UIKit
import Firebase
import FirebaseAuth
import Purchases

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
                
                //Connect Firebase user id with RevenueCat user id (replacing anonymous id)
                if let userUid = user?.uid {
                    Purchases.shared.identify(userUid) { (purchaserInfo, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                }
            } else {
                print("Not Logged in")
                let signup = SignUpVC()
                self?.window?.rootViewController = signup
                
                //Reset RevenueCat user id back to anonymous
                Purchases.shared.reset { (purchaserInfo, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
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
    }
}

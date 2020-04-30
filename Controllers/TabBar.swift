import UIKit

class TabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //    presentSignUp()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupViewControllers()
      //   presentSignUp()
    }
    
//    func presentSignUp() {
//        Auth.auth().addStateDidChangeListener { auth, user in
//            if let user = user {
//                // User is signed in. Show home screen
//                return
//            } else {
//                // No User is signed in. Show user the login screen
//                let viewcontroller = SignUpVC()
//                viewcontroller.modalPresentationStyle = .fullScreen
//                self.present(viewcontroller, animated: true, completion: nil)
//            }
//        }
//    }
    
    func setupViewControllers() {
        viewControllers = [
            generateNavigationController(for: BookingsVC(), title: "Bookings", image: UIImage(systemName: "calendar")!),
            generateNavigationController(for: HomeVC(), title: "Live Class", image: UIImage(systemName: "play.rectangle")!),
            generateNavigationController(for: ProfileVC(), title: "Profile", image: UIImage(systemName: "person")!)
        ]
    }
    
    fileprivate func generateNavigationController(for rootViewController: UIViewController,
                                                  title: String,
                                                  image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}

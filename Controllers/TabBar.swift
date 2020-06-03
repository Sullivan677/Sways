import UIKit
import FirebaseAuth
class TabBar: UITabBarController {
    
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupViewControllers()
    }
 
    func setupViewControllers() {
        viewControllers = [
            generateNavigationController(for: BookingsVC(), title: NSLocalizedString("Bookings", comment: ""), image: UIImage(systemName: "calendar")!),
            generateNavigationController(for: HomeVC(), title: NSLocalizedString("Live Class", comment: ""), image: UIImage(systemName: "play.rectangle")!),
            generateNavigationController(for: ProfilVC(), title: NSLocalizedString("Profile", comment: ""), image: UIImage(systemName: "person")!)
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

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .cancel) { (action) in
        }
        alertVC.addAction(okayAction)
        
        present(alertVC, animated: true, completion: nil)
    }
}

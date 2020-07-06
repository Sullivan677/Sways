import UIKit
import WebKit
class StreamVC: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var workout: Workout!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Live", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissSelf))
        view.backgroundColor = .white
        
        let url = URL(string: "\(workout.URLClass)")!
        webView.load(URLRequest(url: url))
    }
    
    @objc func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
}

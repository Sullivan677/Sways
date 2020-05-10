import UIKit
import WebKit

class StreamVC: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var workout: Workout!
    var request: Request!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Join Live", comment: "")
        view.backgroundColor = .white
        let url = URL(string: "\(request.URLClass ?? "")")!
        webView.load(URLRequest(url: url))
    }

}


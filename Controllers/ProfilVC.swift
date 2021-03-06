import SafariServices
import FirebaseAuth
import UIKit

class ProfilVC: UIViewController, UITableViewDelegate, SFSafariViewControllerDelegate {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var safeArea: UILayoutGuide!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.title = NSLocalizedString("Profile", comment: "")
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
    
    func SignOut() {
          let firebaseAuth = Auth.auth()
          do {
              try firebaseAuth.signOut()
            print("user logout")
          } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            let alert = UIAlertController(title: "Error", message: "We were not able to sign you out, check your internet connection.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
          }
      }
    
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 4  {
            SignOut()
        } else if indexPath.section == 2 {
            let item: [Any] = ["Check out Sways", URL(string: "https://apps.apple.com/app/id1504080698")!]
            let vc = UIActivityViewController(activityItems: item, applicationActivities: nil)
            present(vc, animated: true)
        } else if indexPath.section == 3 {
            //link to referalVC
            let safariVC = SFSafariViewController(url: (NSURL(string: "https://sullivandecarli.typeform.com/to/ZlmcNw5H")! as? URL)!)
            present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self
        } else {
            let row = dataSource[indexPath.section].rows[indexPath.row]
            let safariVC = SFSafariViewController(url: (NSURL(string: row.URL!)! as? URL)!)
            present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self
        }
    }

    func showSafariVC(for url: String) {
        guard let url = URL(string: url) else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}

extension ProfilVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 3 {
            let referalCell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            referalCell.accessoryType = .disclosureIndicator
            referalCell.textLabel?.text = NSLocalizedString("Refered by a trainer?", comment: "")
            referalCell.detailTextLabel?.text = NSLocalizedString("Get your travel yoga mat", comment: "")
            referalCell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
            referalCell.detailTextLabel?.font = .systemFont(ofSize: 18, weight: .regular)
            referalCell.selectionStyle = .none
            return referalCell
        }
        if indexPath.section == 2 {
            let shareCell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            shareCell.accessoryType = .disclosureIndicator
            shareCell.textLabel?.text = NSLocalizedString("Share the app", comment: "")
            shareCell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
            shareCell.selectionStyle = .none
            return shareCell
        } else if indexPath.section == 4 {
            let authCell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            authCell.accessoryType = .disclosureIndicator
            authCell.textLabel?.text = "Log Out"
            authCell.detailTextLabel?.text = "Get back soon!"
            authCell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
            authCell.detailTextLabel?.font = .systemFont(ofSize: 18, weight: .regular)
            authCell.selectionStyle = .none
            return authCell
        } else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            let row = dataSource[indexPath.section].rows[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = row.title
            cell.detailTextLabel?.text = row.subtitle
            cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
            cell.detailTextLabel?.font = .systemFont(ofSize: 18, weight: .regular)
            cell.detailTextLabel?.textColor = .darkGray
            cell.selectionStyle = .none
            return cell
        }
        }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "About"
        } else if section == 1 {
            return "Legal"
        } else if section == 2 {
            return "Share"
        }  else if section == 3 {
            return "Referral"
        } else {
            return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else if section == 1 {
            return 2
        } else {
            return 1
        }
    }
}

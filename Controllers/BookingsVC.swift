import UIKit
import FirebaseAuth
import SafariServices

class BookingsVC: UITableViewController, SFSafariViewControllerDelegate {
    
    private var authIdentifier = ""
    let profilPicture = UIImageView()
    private var allRequests = [Request]() {
        didSet {
            DispatchQueue.main.async {
                self.requests = self.allRequests
            }
        }
    }
    
    var request: Request!
    
    var requests = [Request]() {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    private var service: RequestUser?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .semibold)
        label.numberOfLines = -1
        label.text = "Nothing planned."
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = -1
        label.text = "Start browsing classes for your next workout."
        return label
    }()
    
    private let exploreButton: UIButton = {
        let bottomButton = UIButton()
        bottomButton.setTitle("Explore Sways", for: .normal)
        bottomButton.backgroundColor = .black
        bottomButton.setTitleColor(.white, for: .normal)
        bottomButton.layer.cornerRadius = 8
        bottomButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        bottomButton.addTarget(self, action: #selector(moveTab), for: .touchUpInside)
        return bottomButton
    }()
    
    private let bookingImage: UIImageView = {
        let yogaImage = UIImageView()
        yogaImage.image = UIImage(named:"yoga-bookings")
        return yogaImage
    }()
    
    @objc func moveTab() {
        tabBarController?.selectedIndex = 1
    }
    
    private lazy var emptyView: UIView = {
        let view = UIView()
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(exploreButton)
        view.addSubview(bookingImage)
        bookingImage.translatesAutoresizingMaskIntoConstraints = false
        bookingImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bookingImage.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -60).isActive = true
        bookingImage.heightAnchor.constraint(equalToConstant: 240).isActive = true
        bookingImage.widthAnchor.constraint(equalToConstant: 300).isActive = true
        exploreButton.translatesAutoresizingMaskIntoConstraints = false
        exploreButton.widthAnchor.constraint(equalToConstant: 220).isActive = true
        exploreButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        exploreButton.layer.cornerRadius = 22
        exploreButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100).isActive = true
        exploreButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.widthAnchor.constraint(equalToConstant: 260).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -10).isActive = true
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        subtitleLabel.bottomAnchor.constraint(equalTo: exploreButton.topAnchor, constant: -30).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18).isActive = true
        return view
    }()
    
    var isAuthenticated: Bool { return Auth.auth().currentUser != nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bookings"
        loadData()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let uid = Auth.auth().currentUser?.uid else { resetInformation(); return }
        if uid != authIdentifier {
            loadData()
        }
    }
    
    private func resetInformation() {
        authIdentifier = ""
        requests = []
        service = nil
    }
    
    func loadData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        authIdentifier = uid
        service = RequestUser()
        service?.get { requests in
            self.allRequests = requests
        }
    }
    
    private func updateUI() {
        tableView.separatorStyle = requests.isEmpty ? .none : .singleLine
        tableView.backgroundView = requests.isEmpty ? emptyView : nil
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.reloadData()
    }
    
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return requests.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellId")
        cell.selectionStyle = .none
        let request = requests[indexPath.row]
        cell.backgroundColor = .none
        cell.detailTextLabel?.text = "Password: \(request.passwordClass  ?? "")"
        cell.textLabel?.text = "\(request.date ?? "") at \(request.time ?? "")"
        cell.textLabel?.numberOfLines = -1
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        cell.detailTextLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        cell.detailTextLabel?.textColor = .darkGray
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = requests[indexPath.row]
        let vc = StreamVC()
        vc.request = request
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

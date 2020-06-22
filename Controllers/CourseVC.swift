import UIKit
import FirebaseAuth

class CourseVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        loadData()
        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.register(CategoriesCell.self, forCellReuseIdentifier: "sportsCell")
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
    
    private var authIdentifier = ""
    let profilPicture = UIImageView()
    private var allCollection = [Collectionn]() {
        didSet {
            DispatchQueue.main.async {
                self.collections = self.allCollection
            }
        }
    }
    
    var collection: Collectionn!
    var collections = [Collectionn]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var service: CollectionService?
    
    func loadData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        authIdentifier = uid
        service = CollectionService()
        service?.get { collections in
            self.allCollection = collections
        }
    }
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return collections.count
    }
    
    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sportsCell", for: indexPath) as! CategoriesCell
        cell.clipsToBounds = true
        cell.selectionStyle = .none
        let sport = collections[indexPath.row]
        cell.collectionTitle.text = sport.title
        cell.trainerName.text = "\(sport.numberClasses)"
        if let url = URL(string: sport.headerCollection!) {
            cell.sportImageView.kf.setImage(with: url)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collection = collections[indexPath.row]
        let vc = DetailsVideoVC()
        vc.collection = collection
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

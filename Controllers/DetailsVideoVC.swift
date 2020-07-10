import UIKit
import FirebaseFirestore
import SafariServices
import FirebaseAuth
import AVKit
import Purchases

class DetailsVideoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate  {
    
    private var service: VideoService?
    private var authIdentifier = ""
    let tableView = UITableView(frame: .zero, style: .grouped)
    let profilPicture = UIImageView()
    let headerImage = UIImageView()
    private var allvideo = [Video]() {
        didSet {
            DispatchQueue.main.async {
                self.videos = self.allvideo
            }
        }
    }
    var collection: Collectionn!
    var video: Video!
    var videos = [Video]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(collection.title ?? "")"
        loadData()
        setupTableView()
        tableView.register(videoCell.self,
                           forCellReuseIdentifier: videoCell.identifier)
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        if let pictureCollection = collection?.headerCollection, let url = URL(string: pictureCollection) {
            headerImage.kf.setImage(with: url)
        }
    }
    
//    @objc func showRestoredAlert() {
//        let alert = UIAlertController(title: "Success!", message: "Your purchases were successfully restored.", preferredStyle: .alert)
//        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
//    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }

    func loadData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        authIdentifier = uid
        service = VideoService()
        service?.get(collectionID: collection.identifier) { videos in
            self.allvideo = videos
        }
    }
    
     func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return videos.count
    }
    
    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let centerCell = tableView.dequeueReusableCell(withIdentifier: videoCell.identifier) as? videoCell
        guard let cell = centerCell else { return UITableViewCell() }
        let video = videos[indexPath.row]
        cell.courseTitle.text = video.title
        if let url = URL(string: video.videoImage) {
            cell.courseImage.kf.setImage(with: url)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            DispatchQueue.main.async {
                //Check for 'subscribed' entitlement which means subscription is active
                if purchaserInfo?.entitlements.all[RevenueCatEntitlementsSubscribedID]?.isActive == true {
                    let video = self.videos[indexPath.row]
                    let videoURL = NSURL(string: "\(video.videoURL ?? "")")
                    let player = AVPlayer(url: videoURL! as URL)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    self.present(playerViewController, animated: true)
                    {
                       playerViewController.player!.play()
                    }
                } else {
                    let vc = MembershipVC()
                    let navigationController = UINavigationController(rootViewController: vc)
                    self.present(navigationController, animated: true)
                }
            }
        }
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 400
    }
}

import UIKit
import FirebaseFirestore
import MessageUI
import AVFoundation
class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cellId"
    let tableView = UITableView(frame: .zero, style: .grouped)
    var safeArea: UILayoutGuide!
    let classPicture = UIImageView()
    var workout: Workout!
    private var service: WorkoutService?
    var workouts = [Workout]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.separatorStyle = .none
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(WorkoutCell.self, forCellReuseIdentifier: WorkoutCell.identifier)
        setupTableView()
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
        if let pictureClass = workout?.classImage, let url = URL(string: pictureClass) {
            classPicture.kf.setImage(with: url)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = true
        tableView.isUserInteractionEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
    
      func loadData() {
         service = WorkoutService()
         service?.get { [weak self] classes in
            self?.workouts = classes.filter { (workoutService) -> Bool in
                 workoutService.classActive != false
             }.sorted(by: { (a, b) -> Bool in
                 a.dateClass < b.dateClass
             })
            self?.tableView.reloadData()
         }
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let workoutCell = tableView.dequeueReusableCell(withIdentifier: WorkoutCell.identifier) as? WorkoutCell
       guard let cell = workoutCell else { return UITableViewCell() }
       let workout = workouts[indexPath.row]
        cell.titleClass.text = workout.classTitle
        cell.titleClass.numberOfLines = 4
        cell.dateClass.text = workout.dateString
        cell.selectionStyle = .none
        if let url = URL(string: workout.classImage) {
            cell.classImage.kf.setImage(with: url)
       }
        return cell
    }
    
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let works = workouts[indexPath.row]
        let vc = DetailsVC()
        vc.workout = works
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  520
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection  section: Int) -> UIView? {
        let footerView  = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height));
        let bigTitle = UILabel(frame: CGRect(x: 20, y: 40, width: 250, height: 360))
        let emailButton = UIButton(frame: CGRect(x: 20, y: 440, width: 250, height: 50))
        bigTitle.text = NSLocalizedString("We publish new classes every Sunday at 6:00 p.m - What classes are you interested in?", comment: "")
        bigTitle.numberOfLines = -1
        bigTitle.font = .systemFont(ofSize: 32, weight: .bold)
        emailButton.backgroundColor = .black
        emailButton.setTitle(NSLocalizedString("Suggest a class", comment: ""), for: .normal)
        emailButton.layer.cornerRadius = 25
        emailButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        emailButton.addTarget(self, action: #selector(showMailComposer), for: .touchUpInside)
        footerView.addSubview(bigTitle)
        footerView.addSubview(emailButton)
        return footerView
    }
    
    @objc func showMailComposer() {
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["hello@sways.app"])
        composer.setSubject("Class suggestion")
        composer.setMessageBody("Hey there, I'd like to suggest you ", isHTML: false)
        present(composer, animated: true)
    }
}

extension HomeVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true, completion: nil)
            return
        }
        switch result {
        case .cancelled:
            print("cancelled")
        case .failed:
        print("failed")
        case .saved:
            print("saved")
        case .sent:
            print("sent")
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

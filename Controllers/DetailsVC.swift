import UIKit
import Kingfisher
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Purchases
import EventKit
import EventKitUI

class DetailsVC: UIViewController {

    private var service: WorkoutService?
    var workout: Workout!
    var workouts = [Workout]()
    let toolbar = UIToolbar()
    let bookingButton = UIButton()
    let stackView = UIStackView()
    let priceLabel = UILabel()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var expirationDate: Date?
   let eventStore = EKEventStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar.badge.plus"), style: .plain, target: self, action: #selector(NextCalendar))
        setupToolBar()
        setupButton()
        setupScrollView()
        setupViews()
        ChargeImagesfromURL()
    }
    
    @objc func joinLiveButton() {
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            DispatchQueue.main.async {
                //Check for 'subscribed' entitlement which means subscription is active
                if purchaserInfo?.entitlements.all[RevenueCatEntitlementsSubscribedID]?.isActive == true {
                    let streamVC = StreamVC()
                    streamVC.workout = self.workout
                    let navigationController = UINavigationController(rootViewController: streamVC)
                    self.present(navigationController, animated: true)
                } else {
                    let vc = MembershipVC()
                    let navigationController = UINavigationController(rootViewController: vc)
                    self.present(navigationController, animated: true)
                }
            }
        }
    }
    
    @objc func NextCalendar() {
        addEventToCalendar()
    }
    
     func addEventToCalendar() {
        
        eventStore.requestAccess( to: EKEntityType.event, completion:{(granted, error) in
            DispatchQueue.main.async {
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: self.eventStore)
                    event.title = "\(self.workout.classTitle)"
                    event.startDate = self.workout.dateClass
                    // event.url = self.workout.URLClass
                    event.endDate = self.workout.dateClass + 3600
                    let eventController = EKEventEditViewController()
                    eventController.event = event
                    eventController.eventStore = self.eventStore
                    eventController.editViewDelegate = self
                    self.present(eventController, animated: true, completion: nil)
                    
                }
            }
        })
    }
    
    func ChargeImagesfromURL() {
        if let url = URL(string: workout.classImage) {
            headerImage.kf.setImage(with: url)
        }
        if let profilURL = workout?.pictureTrainer, let url = URL(string: profilURL) {
            profilImage.kf.setImage(with: url)
        }
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: toolbar.topAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    func setupToolBar() {
        view.addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: 80).isActive = true
        toolbar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        toolbar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    func setupButton() {
        view.addSubview(bookingButton)
        bookingButton.backgroundColor = .black
        bookingButton.addTarget(self, action: #selector(joinLiveButton), for: .touchUpInside)
        bookingButton.setTitle("Join Live Class", for: .normal)
        bookingButton.layer.cornerRadius = 25
        bookingButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        bookingButton.translatesAutoresizingMaskIntoConstraints = false
        bookingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bookingButton.bottomAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: -15).isActive = true
        bookingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bookingButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func setupViews() {
        
        contentView.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        titleLabel.text = "\(workout.classTitle)"
        
        contentView.addSubview(headerImage)
        headerImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        headerImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 50).isActive = true
        headerImage.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        headerImage.heightAnchor.constraint(equalToConstant: 390).isActive = true
        headerImage.image = UIImage(named: "\(workout.classImage)")
        
        contentView.addSubview(profilImage)
        profilImage.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: -70).isActive = true
        profilImage.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        profilImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profilImage.heightAnchor.constraint(equalToConstant: 140).isActive = true
        profilImage.image = UIImage(named: "\(workout.pictureTrainer)")
        
        contentView.addSubview(dateLabel)
        dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: profilImage.bottomAnchor, constant: 20).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        dateLabel.text = "Join the live session held in \(workout.language) on \(workout.dateString), \(workout.time ?? "")"
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        descriptionLabel.text = "\(workout.description)"
        
        contentView.addSubview(howitworksLabel)
        howitworksLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        howitworksLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30).isActive = true
        howitworksLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        howitworksLabel.text = "How it works"
        
        contentView.addSubview(termLabel)
        termLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        termLabel.topAnchor.constraint(equalTo: howitworksLabel.bottomAnchor, constant: 5).isActive = true
        termLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        termLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
        termLabel.text = "Click on Join Now when the class start and enjoy your class with your trainer. Can't make it on time? No problem, our classes are recorded and you can access the video for up to 24 hours."
    }
    
    let headerImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let profilImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 36, weight: .heavy)
        label.sizeToFit()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.sizeToFit()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.sizeToFit()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let howitworksLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.sizeToFit()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let termLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.sizeToFit()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
}

extension DetailsVC: EKEventEditViewDelegate {

    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}


import UIKit
import Kingfisher
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import StoreKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                                            style: .plain, target: self,
                                                                   action: #selector(share))
        setupToolBar()
        setupButton()
        setupScrollView()
        setupViews()
        ChargeImagesfromURL()
        NotificationCenter.default.addObserver(self, selector: #selector(subscriptionStatusWasChanged(_:)), name: NSNotification.Name(IAPSubInfoChangeNotification), object: nil)
    }

    
    @objc func subscriptionStatusWasChanged(_ notification: Notification) {
          guard let status = notification.object as? Bool else {return}
            DispatchQueue.main.async {
         
              IAPService.instance.isSubscriptionActive { (status) in
                  if status == true {
                      //button links to StreamVC
                      let vc = StreamVC()
                      let navigationController = UINavigationController(rootViewController: vc)
                      navigationController.modalPresentationStyle = .fullScreen
                      self.present(navigationController, animated: true, completion: nil)
                  } else {
                      //Button links to MembershipVC
                      let vc = MembershipVC()
                      let navigationController = UINavigationController(rootViewController: vc)
                      navigationController.modalPresentationStyle = .fullScreen
                      self.present(navigationController, animated: true) {
                          self.view.activityStopAnimating()
                      }
                      self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
                  }
              }
          }
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IAPService.instance.isSubscriptionActive { (active) in
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func share() {
        let item: [Any] = ["Check out the class, \(workout.classTitle) on Sways", URL(string: "https://apps.apple.com/app/id1504080698")!]
        let vc = UIActivityViewController(activityItems: item, applicationActivities: nil)
        present(vc, animated: true)
    }
    
    @objc func joinLiveButton() {
        IAPService.instance.isSubscriptionActive { (status) in
            if status == true {
                //button links to StreamVC
                let vc = StreamVC()
                vc.workout = self.workout
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                
                let vc = MembershipVC()
                let navigationController = UINavigationController(rootViewController: vc)
                self.present(navigationController, animated: true) {
                    self.view.activityStopAnimating()
                }
                self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
                
                
            }
        }
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
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
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
        termLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        termLabel.text = "How does it work? After booking the class, you will receive the link to the livestream directly in your bookings. Open the Zoom link 5 minutes before the class starts. Can't make it on time? No problem, our classes are recorded and you can access the video for up to 24 hours. Class held in \(workout?.language ?? "")"
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
              label.textColor = .darkGray
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

extension DetailsVC: IAPServiceDelegate {
    func iapProductsLoaded() {
        print("IAP PRODUCTS LOADED!")
    }
}

extension UIView{

func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor) {
    let backgroundView = UIView()
    backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
    backgroundView.backgroundColor = backgroundColor
    backgroundView.tag = 475647

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
    activityIndicator.center = self.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.style = UIActivityIndicatorView.Style.medium
    activityIndicator.color = activityColor
    activityIndicator.startAnimating()
    self.isUserInteractionEnabled = false

    backgroundView.addSubview(activityIndicator)

    self.addSubview(backgroundView)
}

func activityStopAnimating() {
    if let background = viewWithTag(475647){
        background.removeFromSuperview()
    }
    self.isUserInteractionEnabled = true
}

}


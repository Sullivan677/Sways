import UIKit
import Kingfisher
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import StoreKit

class courseVC: UIViewController {
    
    let productID = "com.Sways.livestreamclass"
    private var service: WorkoutService?
    var workout: Workout!
    var workouts = [Workout]()
    let scrollView = UIScrollView()
    let contentView = UIView()
    let toolbar = UIToolbar()
    let bookingButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                                                   style: .plain, target: self,
                                                                   action: #selector(share))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissSelf))
        setupToolBar()
        setupButton()
        setupScrollView()
        setupViews()
        ChargeImagesfromURL()
      //  SKPaymentQueue.default().add(self)
    }

//    @objc func paymentBooking() {
//        let vc = MembershipVC()
//        let navigationController = UINavigationController(rootViewController: vc)
//        navigationController.modalPresentationStyle = .fullScreen
//        present(navigationController, animated: true, completion: nil)
//    }
    
    @objc func share() {
           let item: [Any] = ["Check out the class, \(workout.classTitle) on Sways", URL(string: "https://apps.apple.com/app/id1504080698")!]
              let vc = UIActivityViewController(activityItems: item, applicationActivities: nil)
              present(vc, animated: true)
          }
    
    @objc func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func ChargeImagesfromURL() {
           if let photoURL = workout?.classImage, let url = URL(string: photoURL) {
               headerImage.kf.setImage(with: url)
           }
        if let profilURL = workout?.pictureTrainer, let url = URL(string: profilURL) {
                      profilImage.kf.setImage(with: url)
                  }
       }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
           for transaction in transactions {
               if transaction.transactionState == .purchased {
                   print("transaction succesfull")
            //remove it from the queue
                   SKPaymentQueue.default().finishTransaction(transaction)
                   submitUserRequest()
                   submitPartnerRequest()
                   let vc = SuccessVC()
                   vc.workout = workout
                   let navigationController = UINavigationController(rootViewController: vc)
                   navigationController.navigationBar.prefersLargeTitles = true
                   navigationController.modalPresentationStyle = .fullScreen
                   present(navigationController, animated: true, completion: nil)
               } else if transaction.transactionState == .failed {
                   print("User unable to make payment")
                   let alert = UIAlertController(title: "Oops!", message: NSLocalizedString("It's look's like an error occured, check your settings", comment: ""), preferredStyle: UIAlertController.Style.alert)
                   alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                   self.present(alert, animated: true, completion: nil)
                   //remove it from the queue
                   SKPaymentQueue.default().finishTransaction(transaction)
               }
              // else if transaction.transactionState == .purchasing
           }
       }
    
    @objc func paymentBooking() {
           if Auth.auth().currentUser?.uid != nil {
               if workout.classFree != true {
                         if SKPaymentQueue.canMakePayments() {
                             let paymentRequest = SKMutablePayment()
                             paymentRequest.productIdentifier = productID
                             SKPaymentQueue.default().add(paymentRequest)
                         } else {
                             print("User unable to make purchase")
                         }
                     } else {
                         submitUserRequest()
                         submitPartnerRequest()
                         let vc = SuccessVC()
                         vc.workout = workout
                         let navigationController = UINavigationController(rootViewController: vc)
                         navigationController.navigationBar.prefersLargeTitles = true
                         navigationController.modalPresentationStyle = .fullScreen
                         present(navigationController, animated: true, completion: nil)
                     }
            } else {
             //user is not logged in
               let vc = SignUpVC()
               let navigationController = UINavigationController(rootViewController: vc)
               present(navigationController, animated: true, completion: nil)
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
        bookingButton.addTarget(self, action: #selector(paymentBooking), for: .touchUpInside)
        bookingButton.setTitle("Book Live Class", for: .normal)
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
        headerImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        headerImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 42).isActive = true
        headerImage.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        headerImage.heightAnchor.constraint(equalToConstant: 260).isActive = true
        headerImage.image = UIImage(named: "\(workout.classImage)")
        
        contentView.addSubview(profilImage)
        profilImage.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: -30).isActive = true
        profilImage.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        profilImage.widthAnchor.constraint(equalToConstant: 140).isActive = true
        profilImage.heightAnchor.constraint(equalToConstant: 140).isActive = true
        profilImage.image = UIImage(named: "\(workout.pictureTrainer)")
        
        contentView.addSubview(dateLabel)
        dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: profilImage.bottomAnchor, constant: 20).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        dateLabel.text = "Join the live session held in \(workout.language) on \(workout.dateString), \(workout.time ?? "")"

        contentView.addSubview(descriptionLabel)
        descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
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
    
    func submitUserRequest() {
          guard let user = Auth.auth().currentUser else {
              return
          }
          
          let userRequest: [String: Any] = [
              "partnerId": workout.identifier,
              "classTitle": workout.classTitle,
              "URLClass": workout.URLClass,
              "date": workout.dateString,
              "time": workout.time,
              "passwordClass": workout.passwordClass,
              "trainerName": workout.trainerName,
              "classImage": workout.classImage
          ]
          Firestore.firestore()
              .collection("User/\(user.uid)/Requests")
              .addDocument(data: userRequest)
      }
      
      func submitPartnerRequest() {
          guard let user = Auth.auth().currentUser else {
              return
          }
          let partnerRequest: [String: Any] = [
              "partnerId": workout.identifier,
              "activityTitle": workout.classTitle,
              "URLClass": workout.URLClass,
              "date": workout.dateString,
              "trainerName": workout.trainerName,
              "clientName": user.displayName,
              "clientIdentifier": user.uid,
              "clientEmail": user.email
          ]
          Firestore.firestore()
              .collection("Workouts/\(workout.identifier)/Requests")
              .addDocument(data: partnerRequest)
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
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.sizeToFit()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
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

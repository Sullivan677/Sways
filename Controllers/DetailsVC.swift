import UIKit
import Kingfisher
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import StoreKit

class DetailsVC: UIViewController, SKPaymentTransactionObserver {

    private var service: WorkoutService?
    let productID = "com.Sways.livestreamclass"
    var workout: Workout!
    var workouts = [Workout]()
    let workoutPicture = UIImageView()
    let toolbar = UIToolbar()
    let bookingButton = UIButton()
    let stackView = UIStackView()
    let descriptionLabel = UILabel()
    let headerLabel = UILabel()
    let infoLabel = UILabel()
    let priceLabel = UILabel()
    let dateLabel = UILabel()
    let nextStepsLabel = UILabel()
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(workout.trainerName)"
        navigationController?.setNavigationBarHidden(false, animated: true)
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                                                   style: .plain, target: self,
                                                                   action: #selector(share))
        setupToolBar()
        setupButton()
        setupScrollView()
        setupStackView()
        ChargeImagesfromURL()
        setupImage()
        setupHeadline()
        setupInfos()
        setupPrice()
        setupDateInfos()
        setupDescription()
        setupNextStep()
        SKPaymentQueue.default().add(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           navigationController?.setNavigationBarHidden(false, animated: true)
       }
    
    @objc func share() {
        let item: [Any] = ["Check out the class, \(workout.classTitle) on Sways", URL(string: "https://apps.apple.com/app/id1504080698")!]
           let vc = UIActivityViewController(activityItems: item, applicationActivities: nil)
           present(vc, animated: true)
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

    func ChargeImagesfromURL() {
        if let photoURL = workout?.classImage, let url = URL(string: photoURL) {
            workoutPicture.kf.setImage(with: url)
        }
    }
    
    func setupScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false;
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true;
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true;
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true;
        self.scrollView.bottomAnchor.constraint(equalTo: self.toolbar.topAnchor).isActive = true;
    }
    
    func setupStackView() {
        self.scrollView.addSubview(self.stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.axis = .vertical
        self.stackView.spacing = 30;
        self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.leadingAnchor).isActive = true;
        self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true;
        self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.trailingAnchor).isActive = true;
        self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true;
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
        bookingButton.setTitle(NSLocalizedString("Book Live Class", comment: ""), for: .normal)
        bookingButton.layer.cornerRadius = 25
        bookingButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        bookingButton.translatesAutoresizingMaskIntoConstraints = false
        bookingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bookingButton.bottomAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: -15).isActive = true
        bookingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bookingButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func setupImage() {
        self.stackView.addArrangedSubview(workoutPicture)
        workoutPicture.translatesAutoresizingMaskIntoConstraints = false
        workoutPicture.contentMode = .scaleAspectFill
        workoutPicture.clipsToBounds = true
        workoutPicture.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        workoutPicture.heightAnchor.constraint(equalToConstant: 450).isActive = true
        workoutPicture.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        workoutPicture.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
    }
    
    func setupHeadline() {
        self.stackView.addArrangedSubview(headerLabel)
        headerLabel.text = "\(workout?.classTitle ?? "")"
        headerLabel.textColor = .black
        headerLabel.font = .systemFont(ofSize: 30, weight: .medium)
        headerLabel.numberOfLines = -1
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.topAnchor.constraint(equalTo: workoutPicture.bottomAnchor, constant: 35).isActive = true
        headerLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 15).isActive = true
    }
    
    func setupInfos() {
        self.stackView.addArrangedSubview(infoLabel)
        infoLabel.text = "⌚️\(workout?.duration ?? 0.0) minute | \(workout?.language ?? "") |"
        infoLabel.textColor = .black
        infoLabel.font = .systemFont(ofSize: 20, weight: .regular)
        infoLabel.numberOfLines = -1
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 12).isActive = true
        infoLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 15).isActive = true
        infoLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -30).isActive = true
    }
    
    func setupPrice() {
        self.stackView.addArrangedSubview(priceLabel)
        if workout.classFree == true {
            priceLabel.text = "💳 Free"
        } else {
            priceLabel.text = NSLocalizedString("💳 4,99$", comment: "")
        }
        priceLabel.textColor = .black
        priceLabel.font = .systemFont(ofSize: 20, weight: .regular)
        priceLabel.numberOfLines = -1
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 8).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 15).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -30).isActive = true
    }
    
    func setupDateInfos() {
        self.stackView.addArrangedSubview(dateLabel)
        dateLabel.text = "Join the live session on \(workout?.dateString ?? ""), \(workout?.time ?? "")"
        dateLabel.textColor = .black
        dateLabel.font = .systemFont(ofSize: 20, weight: .regular)
        dateLabel.numberOfLines = -1
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 25).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -50).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 15).isActive = true
    }
   
    func setupDescription() {
        self.stackView.addArrangedSubview(descriptionLabel)
        descriptionLabel.text = "\(workout?.description ?? "")"
        descriptionLabel.textColor = .black
        descriptionLabel.font = .systemFont(ofSize: 20, weight: .regular)
        descriptionLabel.numberOfLines = -1
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 30).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 15).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -50).isActive = true
    }
    
    func setupNextStep() {
        self.stackView.addArrangedSubview(nextStepsLabel)
        nextStepsLabel.text = "How does it work? After booking the class, you will receive the link to the livestream directly in your bookings. Open the link on \(workout?.date ?? "") at \(workout?.time ?? ""). Can't make it on time? No problem, our classes are recorded and you can access the video for up to 24 hours. Class held in \(workout?.language ?? "")"
        nextStepsLabel.textColor = .black
        nextStepsLabel.font = .systemFont(ofSize: 20, weight: .regular)
        nextStepsLabel.numberOfLines = -1
        nextStepsLabel.translatesAutoresizingMaskIntoConstraints = false
        nextStepsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40).isActive = true
        nextStepsLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 15).isActive = true
        nextStepsLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -50).isActive = true
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
}

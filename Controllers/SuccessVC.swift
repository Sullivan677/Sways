import UIKit
class SuccessVC: UIViewController {
    
    let succesTitle = UILabel()
    let successSubtitle = UILabel()
    let closeButton = UIButton()
    let trophyImage = UIImageView(image: UIImage(named: "trophy"))
    var workout: Workout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupImage()
        setupTitle()
        setupSubtitle()
        setupButton()
    }
    
    func setupImage() {
        view.addSubview(trophyImage)
        trophyImage.translatesAutoresizingMaskIntoConstraints = false
        trophyImage.contentMode = .scaleAspectFit
        trophyImage.clipsToBounds = true
        trophyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        trophyImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 180).isActive = true
        trophyImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        trophyImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setupTitle() {
        view.addSubview(succesTitle)
        succesTitle.text = "See you on the livestream"
        succesTitle.textAlignment = .center
        succesTitle.font = UIFont.boldSystemFont(ofSize: 26)
        succesTitle.numberOfLines = 0
        succesTitle.translatesAutoresizingMaskIntoConstraints = false
        succesTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        succesTitle.topAnchor.constraint(equalTo: trophyImage.bottomAnchor, constant: 20).isActive = true
        succesTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        succesTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
    }
    
    func setupSubtitle() {
        view.addSubview(successSubtitle)
        successSubtitle.text = "Rendez-vous on \(workout.date ?? "") at \(workout.time ?? ""). Find the link to the livestream in your booking."
        successSubtitle.textAlignment = .center
        successSubtitle.numberOfLines = 0
        successSubtitle.translatesAutoresizingMaskIntoConstraints = false
        successSubtitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        successSubtitle.topAnchor.constraint(equalTo: succesTitle.bottomAnchor, constant: 12).isActive = true
        successSubtitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        successSubtitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
    }
    
    func setupButton() {
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        closeButton.setTitle("Close", for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        closeButton.layer.cornerRadius = 25
        closeButton.backgroundColor = .black
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
    
    @objc func closeAction() {
        if let tabBarController = self.presentingViewController as? UITabBarController {
            self.dismiss(animated: true) {
                tabBarController.selectedIndex = 0
            }
        }
    }
}

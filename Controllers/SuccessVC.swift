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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissSelf))
        setupImage()
        setupTitle()
        setupSubtitle()
    }
    
    @objc func dismissSelf() {
           self.dismiss(animated: true, completion: nil)
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
        succesTitle.text = NSLocalizedString("See you on the livestream", comment: "")
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
        successSubtitle.text = "Rendez-vous on \(workout.dateString ?? "") at \(workout.time ?? ""). Find the link to the livestream in your booking."
        successSubtitle.textAlignment = .center
        successSubtitle.numberOfLines = 0
        successSubtitle.translatesAutoresizingMaskIntoConstraints = false
        successSubtitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        successSubtitle.topAnchor.constraint(equalTo: succesTitle.bottomAnchor, constant: 12).isActive = true
        successSubtitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        successSubtitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
    }

}

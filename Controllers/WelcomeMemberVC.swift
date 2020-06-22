import UIKit

class WelcomeMemberVC: UIViewController {

    let scrollView = UIScrollView()
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissSelf))
        setupScrollView()
        setupViews()
    }
    
    @objc func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
    
   func setupScrollView(){
          scrollView.translatesAutoresizingMaskIntoConstraints = false
          contentView.translatesAutoresizingMaskIntoConstraints = false
          
          view.addSubview(scrollView)
          scrollView.addSubview(contentView)
          
          scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
          scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
          scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
          scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
          
          contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
          contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
          contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
          contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
      }
    
    func setupViews() {
        
        contentView.addSubview(headerImage)
        headerImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        headerImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        headerImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        headerImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        contentView.addSubview(headlineLabel)
        headlineLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        headlineLabel.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 10).isActive = true
        headlineLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
        contentView.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 15).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    let headerImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = UIImage(named: "logo-black")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enjoy sport sessions from whenever you are, you have now access to all video contents and live classes held by top trainers. Be ready to sweat!"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.sizeToFit()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let headlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to the community"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 28, weight: .heavy)
        label.sizeToFit()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


}

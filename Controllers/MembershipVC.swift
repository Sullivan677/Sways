import UIKit

class MembershipVC: UIViewController {

    let scrollView = UIScrollView()
    let contentView = UIView()
    let toolbar = UIToolbar()
    let subscribeButton = UIButton()
    let priceLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissSelf))
        view.backgroundColor = .white
        setupToolBar()
        setupButton()
        setupPriceLabel()
        setupScrollView()
        setupViews()
    }
    
    @objc func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupScrollView(){
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
        toolbar.heightAnchor.constraint(equalToConstant: 110).isActive = true
        toolbar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        toolbar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    func setupPriceLabel() {
        view.addSubview(priceLabel)
        priceLabel.text = "Get 7 days free. Then 19,99 EUR per month."
        priceLabel.textColor = .black
        priceLabel.font = .systemFont(ofSize: 16, weight: .regular)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.bottomAnchor.constraint(equalTo: subscribeButton.topAnchor, constant: -12).isActive = true
        priceLabel.centerXAnchor.constraint(equalTo: toolbar.centerXAnchor).isActive = true
    }
    
    func setupButton() {
        view.addSubview(subscribeButton)
        subscribeButton.backgroundColor = .black
     //   subscribeButton.addTarget(self, action: #selector(subscribeFlow), for: .touchUpInside)
        subscribeButton.setTitle("Start your membership", for: .normal)
        subscribeButton.layer.cornerRadius = 25
        subscribeButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        subscribeButton.translatesAutoresizingMaskIntoConstraints = false
        subscribeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subscribeButton.bottomAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: -15).isActive = true
        subscribeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        subscribeButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func setupViews() {
        contentView.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
        contentView.addSubview(headlineLabel)
        headlineLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        headlineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7).isActive = true
        headlineLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
        contentView.addSubview(headerImage)
        headerImage.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 20).isActive = true
        headerImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 42).isActive = true
        headerImage.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        headerImage.heightAnchor.constraint(equalToConstant: 280).isActive = true
        
        
        contentView.addSubview(secondTitlelabel)
        secondTitlelabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        secondTitlelabel.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 20).isActive = true
        secondTitlelabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
        contentView.addSubview(benefitsLabel)
        benefitsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        benefitsLabel.topAnchor.constraint(equalTo: secondTitlelabel.bottomAnchor, constant: 5).isActive = true
        benefitsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
        contentView.addSubview(termTitleLabel)
        termTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        termTitleLabel.topAnchor.constraint(equalTo: benefitsLabel.bottomAnchor, constant: 30).isActive = true
        termTitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
        contentView.addSubview(termLabel)
        termLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        termLabel.topAnchor.constraint(equalTo: termTitleLabel.bottomAnchor, constant: 5).isActive = true
        termLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        termLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    let headerImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage(named: "yoga")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Get unlimited"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.sizeToFit()
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let headlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Unlock unlimited access to live classes & video content"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 28, weight: .heavy)
        label.sizeToFit()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secondTitlelabel: UILabel = {
        let label = UILabel()
        label.text = "What's included"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.sizeToFit()
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let benefitsLabel: UILabel = {
           let label = UILabel()
           label.text = "Unlimited access to video content. \nUnlimited access to live classes, held by certified trainers. \nNew release - video contents are uploaded every month."
           label.numberOfLines = 0
           label.font = .systemFont(ofSize: 18, weight: .regular)
           label.sizeToFit()
           label.textColor = .black
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    let termTitleLabel: UILabel = {
           let label = UILabel()
           label.text = "Subscription terms"
           label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .medium)
           label.sizeToFit()
           label.textColor = .darkGray
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    let termLabel: UILabel = {
             let label = UILabel()
             label.text = "The membership fee will be billed at the beginning of the paying portion of your membership and each month thereafter unless and until you cancel your membership. We automatically bill your payment method each month on the calendar day corresponding to the commencement of your paying membership. We reserve the right to change our billing timing, in particular, if your payment method has not successfully been charged."
             label.numberOfLines = 0
             label.font = .systemFont(ofSize: 15, weight: .regular)
             label.sizeToFit()
             label.textColor = .black
             label.translatesAutoresizingMaskIntoConstraints = false
             return label
         }()
}

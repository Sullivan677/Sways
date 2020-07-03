import UIKit
import Kingfisher

class WorkoutCell: UITableViewCell {
    
    static let identifier = "WorkoutCell"
    var classImage = UIImageView()
    var dateClass = UILabel()
    var titleClass = UILabel()
    var seeMoreLabel = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(classImage)
        addSubview(dateClass)
        addSubview(titleClass)
        addSubview(seeMoreLabel)
        configureDateLabel()
        configureTitleLabel()
        configureSeeMore()
        configureImageView()
        setupImageconstraint()
        setupSeeMoreConstraint()
        setupDateConstraint()
        setupTitleConstraint()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImageView() {
        classImage.layer.cornerRadius = 0
        classImage.contentMode = .scaleAspectFill
        classImage.layer.shadowRadius = 2
        classImage.layer.shadowColor = UIColor.black.cgColor
        classImage.layer.shadowOpacity = 0.25
        classImage.layer.masksToBounds = false
    }
    
    func configureTitleLabel() {
        titleClass.numberOfLines = -1
        titleClass.font = .systemFont(ofSize: 38, weight: .bold)
        titleClass.textColor = .white
        titleClass.layer.shadowColor = UIColor.darkGray.cgColor
        titleClass.layer.shadowRadius = 2.0
        titleClass.layer.shadowOpacity = 1.0
        titleClass.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        titleClass.layer.masksToBounds = false
    }
    
    func configureDateLabel() {
        dateClass.numberOfLines = 0
        dateClass.font = .systemFont(ofSize: 22, weight: .medium)
        dateClass.textColor = .white
        dateClass.layer.shadowColor = UIColor.darkGray.cgColor
        dateClass.layer.shadowRadius = 2.0
        dateClass.layer.shadowOpacity = 1.0
        dateClass.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        dateClass.layer.masksToBounds = false
    }
    
    func configureSeeMore() {
        seeMoreLabel.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        seeMoreLabel.backgroundColor = .black
        seeMoreLabel.setTitleColor(.white, for: .disabled)
        seeMoreLabel.layer.cornerRadius = 8
        seeMoreLabel.setTitle("Join Now", for: .disabled)
        seeMoreLabel.isEnabled = false
    }
    
    func setupSeeMoreConstraint() {
        seeMoreLabel.translatesAutoresizingMaskIntoConstraints = false
        seeMoreLabel.leadingAnchor.constraint(equalTo: classImage.leadingAnchor, constant: 25).isActive = true
        seeMoreLabel.widthAnchor.constraint(equalToConstant: 180).isActive = true
        seeMoreLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        seeMoreLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40).isActive = true
    }
    
    func setupImageconstraint() {
        classImage.translatesAutoresizingMaskIntoConstraints = false
        classImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        classImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        classImage.heightAnchor.constraint(equalToConstant: 470).isActive = true
        classImage.clipsToBounds = true
    }
    
    func setupTitleConstraint() {
        titleClass.translatesAutoresizingMaskIntoConstraints = false
        titleClass.leadingAnchor.constraint(equalTo: classImage.leadingAnchor, constant: 25).isActive = true
        titleClass.widthAnchor.constraint(equalToConstant: 260).isActive = true
        titleClass.bottomAnchor.constraint(equalTo: seeMoreLabel.topAnchor, constant: -15).isActive = true
    }
    
    func setupDateConstraint() {
        dateClass.translatesAutoresizingMaskIntoConstraints = false
        dateClass.leadingAnchor.constraint(equalTo: classImage.leadingAnchor, constant: 25).isActive = true
        dateClass.bottomAnchor.constraint(equalTo: titleClass.topAnchor, constant: -12).isActive = true
    }
}

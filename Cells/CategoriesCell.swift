import UIKit

class CategoriesCell: UITableViewCell {
    
    var sportImageView = UIImageView()
    var collectionTitle = UILabel()
    var trainerName = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(sportImageView)
        addSubview(collectionTitle)
        configureTitleLabel()
        configureImageView()
        setupImageconstraint()
        setupTitleConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImageView() {
        sportImageView.layer.cornerRadius = 0
        sportImageView.contentMode = .scaleAspectFill
        sportImageView.layer.shadowRadius = 2
        sportImageView.layer.shadowColor = UIColor.black.cgColor
        sportImageView.layer.shadowOpacity = 0.25
        sportImageView.layer.masksToBounds = false
    }
    
    func configureTitleLabel() {
        collectionTitle.numberOfLines = -1
        collectionTitle.font = .systemFont(ofSize: 30, weight: .bold)
        collectionTitle.textColor = .white
        collectionTitle.layer.shadowColor = UIColor.black.cgColor
        collectionTitle.layer.shadowRadius = 2.0
        collectionTitle.layer.shadowOpacity = 1.0
        collectionTitle.layer.shadowOffset = CGSize(width: 1.2, height: 1.2)
        collectionTitle.layer.masksToBounds = false
    }
    
    func setupImageconstraint() {
        sportImageView.translatesAutoresizingMaskIntoConstraints = false
        sportImageView.layer.cornerRadius = 0
        sportImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        sportImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        sportImageView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        sportImageView.clipsToBounds = true
    }
    
    func setupTitleConstraint() {
        collectionTitle.translatesAutoresizingMaskIntoConstraints = false
        collectionTitle.leadingAnchor.constraint(equalTo: sportImageView.leadingAnchor, constant: 18).isActive = true
        collectionTitle.widthAnchor.constraint(equalToConstant: 200).isActive = true
        collectionTitle.bottomAnchor.constraint(equalTo: sportImageView.bottomAnchor, constant: -20).isActive = true
    }
}

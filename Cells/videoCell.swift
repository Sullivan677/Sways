import UIKit
import Kingfisher

class videoCell: UITableViewCell {
    static let identifier = "VideoCell"

    var courseImage = UIImageView()
    var courseTitle = UILabel()
    var courseDuration = UILabel()
    var playImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(courseImage)
        addSubview(courseTitle)
        addSubview(courseDuration)
         addSubview(playImage)
        configureimageView()
        configureTitle()
        configureDuration()
        configurePlayImage()
      }
    
    required init?(coder _: NSCoder) {
             fatalError("init(coder:) has not been implemented")
         }
    
    func configureimageView() {
        courseImage.clipsToBounds = true
        courseImage.translatesAutoresizingMaskIntoConstraints = false
        courseImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18).isActive = true
        courseImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18).isActive = true
        courseImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        courseImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        courseImage.heightAnchor.constraint(equalToConstant: 240).isActive = true
    }
    
    func configurePlayImage() {
        playImage.clipsToBounds = true
        playImage.translatesAutoresizingMaskIntoConstraints = false   
        playImage.image = UIImage(systemName: "play.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        playImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        playImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        playImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        playImage.widthAnchor.constraint(equalToConstant: 70).isActive = true

    }
    
    func configureTitle() {
        courseTitle.numberOfLines = -1
        courseTitle.textColor = .black
        courseTitle.font = .systemFont(ofSize: 22, weight: .bold)
        courseTitle.translatesAutoresizingMaskIntoConstraints = false
        courseTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18).isActive = true
        courseTitle.topAnchor.constraint(equalTo: courseImage.bottomAnchor, constant: 15).isActive = true
        courseTitle.widthAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    func configureDuration() {
        courseDuration.numberOfLines = 0
        courseDuration.font = .systemFont(ofSize: 18, weight: .regular)
        courseDuration.translatesAutoresizingMaskIntoConstraints = false
        courseDuration.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18).isActive = true
        courseDuration.topAnchor.constraint(equalTo: courseTitle.bottomAnchor, constant: 5).isActive = true
    }
}

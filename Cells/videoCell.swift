import UIKit
import Kingfisher

class videoCell: UITableViewCell {
    static let identifier = "VideoCell"

    var courseImage = UIImageView()
    var courseTitle = UILabel()
    var playButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(courseImage)
        addSubview(courseTitle)
        addSubview(playButton)
        configureimageView()
        configureTitle()
        configurePlayButton()
      }
    
    required init?(coder _: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    func configureimageView() {
        courseImage.clipsToBounds = true
        courseImage.translatesAutoresizingMaskIntoConstraints = false
        courseImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        courseImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        courseImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        courseImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        courseImage.heightAnchor.constraint(equalToConstant: 240).isActive = true
    }
  
    func configureTitle() {
        courseTitle.numberOfLines = -1
        courseTitle.textColor = .black
        courseTitle.font = .systemFont(ofSize: 24, weight: .medium)
        courseTitle.translatesAutoresizingMaskIntoConstraints = false
        courseTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18).isActive = true
        courseTitle.topAnchor.constraint(equalTo: courseImage.bottomAnchor, constant: 15).isActive = true
        courseTitle.widthAnchor.constraint(equalToConstant: 180).isActive = true
    }
 
    func configurePlayButton() {
        playButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        playButton.backgroundColor = .black
        playButton.setTitleColor(.white, for: .disabled)
        playButton.layer.cornerRadius = 8
        playButton.setTitle("Play Now", for: .disabled)
        playButton.isEnabled = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18).isActive = true
        playButton.topAnchor.constraint(equalTo: courseTitle.bottomAnchor, constant: 8).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
    }
}

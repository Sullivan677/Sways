struct Video {
    let videoURL: String?
    let title: String?
    let duration: Double
    let videoImage: String
}

extension Video: Equatable, Hashable {}

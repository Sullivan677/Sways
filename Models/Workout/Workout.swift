struct Workout {
    let identifier: String
    let classActive: Bool
    let classFree: Bool
    let classTitle: String
    let classImage: String
    let URLClass: String
    let passwordClass: String
    let date: String
    let time: String?
    let duration: Double
    let language: String
    let trainerName: String
    let description: String
    let information: String
    let pictureTrainer: String
}

extension Workout: Equatable, Hashable {}

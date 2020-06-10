import Foundation

struct Workout {
    let identifier: String
    let classActive: Bool
    let classFree: Bool
    let classTitle: String
    let classImage: String
    let URLClass: String
    let passwordClass: String
    let dateClass: Date
    let time: String?
    let duration: Double
    let language: String
    let trainerName: String
    let description: String
    let information: String
    let pictureTrainer: String
    
    var dateString: String {
           let formatter = DateFormatter()
           formatter.dateFormat = "EEEE, dd 'of' MMMM"
           return formatter.string(from: dateClass)
       }
}

extension Workout: Equatable, Hashable {}

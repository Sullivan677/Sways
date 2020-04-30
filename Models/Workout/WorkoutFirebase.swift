import FirebaseFirestore

extension Workout {
    static func build(from documents: [QueryDocumentSnapshot]) -> [Workout] {
        var workouts = [Workout]()
        for document in documents {
            workouts.append(Workout(identifier: document.documentID,
                                    classActive: document["classActive"] as? Bool ?? false,
                                    classFree: document["classFree"] as? Bool ?? false,
                                    classTitle: document["classTitle"] as? String ?? "",
                                    classImage: document["classImage"] as? String ?? "",
                                    URLClass: document["URLClass"] as? String ?? "",
                                    passwordClass: document["passwordClass"] as? String ?? "",
                                    date: document["date"] as? String ?? "",
                                    time: document["time"] as? String ?? "",
                                    duration: document["duration"] as? Double ?? 0.0,
                                    language: document["language"] as? String ?? "",
                                    trainerName: document["trainerName"] as? String ?? "",
                                    description: document["description"] as? String ?? "",
                                    information: document["information"] as? String ?? "",
                                    pictureTrainer: document["pictureTrainer"] as? String ?? ""))
        }
        return workouts
    }
}

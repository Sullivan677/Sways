import FirebaseFirestore

extension Request {
    static func build(from documents: [QueryDocumentSnapshot]) -> [Request] {
        var requests = [Request]()
        for document in documents {
            requests.append(Request(classTitle: document["classTitle"] as? String ?? "",
                                    date: document["date"] as? String ?? "",
                                    time: document["time"] as? String ?? "",
                                    URLClass: document["URLClass"] as? String ?? "",
                                    passwordClass: document["passwordClass"] as? String ?? "",
                                    classImage: document["classImage"] as? String ?? "",
                                    partnerId: document["partnerId"] as? String ?? "",
                                    category: document["category"] as? String ?? "",
                                    price: document["price"] as? Double ?? 0.0,
                                    trainerName: document["trainerName"] as? String ?? "",
                                    clientName: document["clientName"] as? String ?? "",
                                    clientEmail: document["clientEmail"] as? String ?? "",
                                    clientIdentifier: document["clientIdentifier"] as? String ?? ""))
        }
        return requests
    }
}

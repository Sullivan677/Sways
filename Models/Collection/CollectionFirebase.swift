import FirebaseFirestore

extension Collectionn {
    static func build(from documents: [QueryDocumentSnapshot]) -> [Collectionn] {
        var collections = [Collectionn]()
        for document in documents {
            collections.append(Collectionn(identifier: document.documentID,
                                          title: document["title"] as? String ?? "",
                                          headerCollection: document["headerCollection"] as? String ?? "",
                                          description: document["description"] as? String ?? "",
                                          numberClasses: document["numberClasses"] as? Double ?? 0.0,
                                          totalDuration: document["totalDuration"] as? Double ?? 0.0
            ))
        }
        return collections
    }
}

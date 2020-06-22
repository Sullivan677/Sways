import FirebaseFirestore
import FirebaseAuth

class CollectionService {
    let database = Firestore.firestore()

    func get(handler: @escaping ([Collectionn]) -> Void) {
        database.collection("collections")
            .addSnapshotListener { querySnapshot, err in
                if let error = err {
                    print(error)
                    handler([])
                } else {
                    handler(Collectionn.build(from: querySnapshot?.documents ?? []))
                }
            }
    }
}

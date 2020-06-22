import FirebaseFirestore
import FirebaseAuth

class VideoService {
    let database = Firestore.firestore()
    var collectione: Collectionn!

    func get(collectionID: String, handler: @escaping ([Video]) -> Void) {
        database.collection("collections")
        .document(collectionID)
        .collection("videos")
            .addSnapshotListener { querySnapshot, err in
                if let error = err {
                    print(error)
                    handler([])
                } else {
                    handler(Video.build(from: querySnapshot?.documents ?? []))
                }
            }
    }
}

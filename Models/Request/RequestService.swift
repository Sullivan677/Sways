import FirebaseFirestore

class RequestService {
    let database = Firestore.firestore()

    func get(handler: @escaping ([Request]) -> Void) {
        database.collection("Requests")
            .addSnapshotListener { querySnapshot, err in
                if let error = err {
                    print(error)
                    handler([])
                } else {
                    handler(Request.build(from: querySnapshot?.documents ?? []))
                }
            }
    }
}

import FirebaseFirestore
import FirebaseAuth

class RequestUser {
    let database = Firestore.firestore()
    func get(handler: @escaping ([Request]) -> Void) {
        guard let user = Auth.auth().currentUser else {
                  return
              }
        database.collection("User/\(user.uid)/Requests").addSnapshotListener { querySnapshot, err in
                if let error = err {
                    print(error)
                    handler([])
                } else {
                    handler(Request.build(from: querySnapshot?.documents ?? []))
                }
            }
    }
}

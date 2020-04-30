import FirebaseFirestore

class WorkoutService {
    let database = Firestore.firestore()

    func get(handler: @escaping ([Workout]) -> Void) {
        database.collection("Workouts")
            .addSnapshotListener { querySnapshot, err in
                if let error = err {
                    print(error)
                    handler([])
                } else {
                    handler(Workout.build(from: querySnapshot?.documents ?? []))
                }
            }
    }
}

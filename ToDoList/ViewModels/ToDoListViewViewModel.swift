// ViewModels/ToDoListViewViewModel.swift
import Foundation
import FirebaseFirestore
import FirebaseAuth

class ToDoListViewViewModel: ObservableObject {
    @Published var showingNewItemView = false
    @Published var items: [ToDoListItem] = []

    private let userId: String
    private var listenerRegistration: ListenerRegistration?

    init(userId: String) {
        self.userId = userId
        fetchToDoItems()
    }

    deinit {
        listenerRegistration?.remove()
        print("ToDoListViewViewModel for user \(userId) deinitialized and listener removed.")
    }

    func fetchToDoItems() {
        guard !userId.isEmpty else {
            print("Error: User ID is empty, cannot fetch to-do items.")
            return
        }

        let db = Firestore.firestore()
        let query = db.collection("users")
            .document(userId)
            .collection("todos")
            .order(by: "createdDate", descending: true)

        self.listenerRegistration = query.addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching to-do items: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No documents found in 'todos' collection for user \(self.userId).")
                self.items = []
                return
            }

            self.items = documents.compactMap { documentSnapshot -> ToDoListItem? in
                let data = documentSnapshot.data() // This is [String: Any]
                let documentId = documentSnapshot.documentID // The ID of the document

                print("Attempting to decode document ID: \(documentId) with data: \(data)") // DEBUG
                
                // Use the manual failable initializer
                let item = ToDoListItem(id: documentId, dictionary: data)
                if item == nil {
                    print("Failed to decode document ID: \(documentId)") // DEBUG
                }
                return item
            }
            print("Fetched \(self.items.count) to-do items for user \(self.userId)")
        }
    }
}

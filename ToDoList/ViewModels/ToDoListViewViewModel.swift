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
        // ... (fetchToDoItems function remains the same as before)
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
                do {
                    let item = try documentSnapshot.data(as: ToDoListItem.self)
                    // print("Fetched and decoded item ID: \(item.id ?? "nil"), Title: \(item.title)")
                    return item
                } catch {
                    print("Error decoding to-do item from Firestore: \(error.localizedDescription)")
                    // print("Document data that failed to decode: \(documentSnapshot.data())")
                    return nil
                }
            }
            // print("Fetched \(self.items.count) to-do items for user \(self.userId)")
        }
    }

    // --- NEW FUNCTION ---
    func delete(itemId: String) {
        guard !userId.isEmpty else {
            print("Error: User ID is empty, cannot delete item.")
            return
        }
        
        guard !itemId.isEmpty else {
            print("Error: Item ID is empty, cannot delete.")
            return
        }

        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("todos")
            .document(itemId)
            .delete { error in
                if let error = error {
                    print("Error deleting item \(itemId): \(error.localizedDescription)")
                    // Optionally, show an error message to the user
                } else {
                    print("Successfully deleted item \(itemId)")
                    // The snapshot listener will automatically update the `items` array,
                    // so no manual removal from `self.items` is typically needed here.
                }
            }
    }
}

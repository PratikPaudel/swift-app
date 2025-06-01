// ViewModels/ToDoListItemViewViewModel.swift
import Foundation
import FirebaseAuth
import FirebaseFirestore

class ToDoListItemViewViewModel: ObservableObject {
    // No need to @Published the item itself if the parent list (ToDoListViewViewModel.items)
    // is the source of truth and will re-render the whole list upon Firestore update.
    // However, if you want ToDoListItemView to react independently to its own item changes
    // without waiting for the whole list to refresh (e.g., for instant UI feedback on toggle),
    // you could publish it. For simplicity with Firestore listeners, often not needed.

    private let userId: String // Needed to construct the Firestore path

    init(userId: String) {
        self.userId = userId
    }

    func toggleIsDone(item: ToDoListItem) {
        guard let itemId = item.id else {
            print("Error: Item ID is nil, cannot toggle isDone status.")
            return
        }

        // Create a mutable copy to update the isDone status
        var itemCopy = item
        itemCopy.setDone(!item.isDone) // Toggle the status

        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("todos")
            .document(itemId)
            .updateData(["isDone": itemCopy.isDone]) { error in // Update only the 'isDone' field
                if let error = error {
                    print("Error updating isDone status: \(error.localizedDescription)")
                    // Optionally, revert the UI change or show an error
                } else {
                    print("Successfully updated isDone status for item: \(itemId) to \(itemCopy.isDone)")
                    // The snapshot listener in ToDoListViewViewModel will automatically
                    // receive this update and refresh the items list, causing the UI to update.
                }
            }
    }
}

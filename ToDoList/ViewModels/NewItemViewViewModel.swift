// ViewModels/NewItemViewViewModel.swift
import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewItemViewViewModel: ObservableObject {
    @Published var title = ""
    @Published var dueDate = Date() // Default to today
    @Published var showAlert = false
    @Published var alertMessage = ""

    init() {}

    func save() {
        guard canSave else {
            return
        }

        // Get current user ID
        guard let uId = Auth.auth().currentUser?.uid else {
            alertMessage = "Error: Could not find user ID. Please try logging in again."
            showAlert = true
            return
        }

        // Create model
        let newId = UUID().uuidString // Generate a client-side ID for the new item
        let newItem = ToDoListItem(
            id: newId,
            title: title,
            dueDate: dueDate.timeIntervalSince1970,
            createdDate: Date().timeIntervalSince1970,
            isDone: false
        )

        // Save model to Firestore
        let db = Firestore.firestore()
        db.collection("users")
            .document(uId)
            .collection("todos") // Subcollection for user's to-do items
            .document(newId)     // Use the generated ID
            .setData(newItem.asDictionary()) { [weak self] error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.alertMessage = "Error saving item: \(error.localizedDescription)"
                        self?.showAlert = true
                    } else {
                        print("New item saved successfully.")
                    }
                }
            }
    }

    var canSave: Bool {
        alertMessage = "" // Clear previous messages
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please enter a title for the item."
            // showAlert = true
            return false
        }

        // Due date should be today or later (86400 seconds in a day)
        // Subtract a small buffer (e.g., a minute) to account for slight time differences
        // or if the user picks "today" exactly at midnight.
        guard dueDate.timeIntervalSince1970 >= Calendar.current.startOfDay(for: Date()).timeIntervalSince1970 - 60 else {
            alertMessage = "Due date cannot be in the past."
            // showAlert = true
            return false
        }
        return true
    }
}

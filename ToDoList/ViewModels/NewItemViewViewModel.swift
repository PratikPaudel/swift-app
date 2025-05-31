// ViewModels/NewItemViewViewModel.swift
import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewItemViewViewModel: ObservableObject {
    @Published var title = ""
    @Published var dueDate = Date()
    @Published var showAlert = false
    @Published var alertMessage = ""

    init() {}

    func save() {
        guard canSave else {
            if !alertMessage.isEmpty { showAlert = true }
            return
        }

        guard let uId = Auth.auth().currentUser?.uid else {
            alertMessage = "Error: Could not find user ID. Please try logging in again."
            showAlert = true
            return
        }

        let newDocumentId = UUID().uuidString // This ID will be the name of the document in Firestore
        
        // Create the ToDoListItem using the explicit initializer
        let newItem = ToDoListItem(
            id: newDocumentId, // Pass the ID we'll use for the document path
            title: title,
            dueDate: dueDate.timeIntervalSince1970,
            createdDate: Date().timeIntervalSince1970,
            isDone: false
        )

        print("--- Preparing to save (Manual ID and Dict) ---")
        print("NewItem object: \(newItem)")
        
        // Get the dictionary of fields to save (this excludes 'id')
        let itemFieldsToSave = newItem.dataForFirestore
        print("Item fields for Firestore: \(itemFieldsToSave)")

        if itemFieldsToSave.isEmpty && !newItem.title.isEmpty {
             print("CRITICAL: dataForFirestore returned empty for a non-empty item title: \(newItem.title).")
             alertMessage = "Internal error: Could not prepare item for saving."
             showAlert = true
             return
        }

        let db = Firestore.firestore()
        db.collection("users")
            .document(uId)
            .collection("todos")
            .document(newItem.id) // Use the ID from the newItem object for the document path
            .setData(itemFieldsToSave) { [weak self] error in // Save the fields dictionary
                DispatchQueue.main.async {
                    if let error = error {
                        self?.alertMessage = "Error saving item: \(error.localizedDescription)"
                        self?.showAlert = true
                        print("Firestore setData error: \(error.localizedDescription)")
                    } else {
                        print("New item saved successfully with document ID: \(newItem.id)")
                    }
                }
            }
    }

    var canSave: Bool {
        alertMessage = ""
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please enter a title for the item."
            return false
        }
        guard dueDate.timeIntervalSince1970 >= Calendar.current.startOfDay(for: Date()).timeIntervalSince1970 - 60 else {
            alertMessage = "Due date cannot be in the past."
            return false
        }
        return true
    }
}

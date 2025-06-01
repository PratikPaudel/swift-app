// ViewModels/NewItemViewViewModel.swift
import Foundation
import FirebaseAuth
import FirebaseFirestore // This now includes the Swift extensions

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

        let newDocumentId = UUID().uuidString // We will use this for the document path

        // Create the ToDoListItem. The 'id' field here can be nil or set,
        // but @DocumentID will be populated from the document path when reading.
        // When writing with setData(from:), the @DocumentID field is generally ignored for the written fields.
        let newItem = ToDoListItem(
            // id: newDocumentId, // Optional to set here for client-side reference
            title: title,
            dueDate: dueDate.timeIntervalSince1970,
            createdDate: Date().timeIntervalSince1970,
            isDone: false
        )

        print("--- Preparing to save (using setData from model) ---")
        print("NewItem object: \(newItem)")

        let db = Firestore.firestore()
        let documentRef = db.collection("users")
            .document(uId)
            .collection("todos")
            .document(newDocumentId) // Explicitly set the document ID for the path

        do {
            // Use setData(from: model) which leverages Firestore's Codable support
            // This correctly handles types like @DocumentID (by not trying to write it as a field)
            try documentRef.setData(from: newItem) { [weak self] error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.alertMessage = "Error saving item: \(error.localizedDescription)"
                        self?.showAlert = true
                        print("Firestore setData(from:) error: \(error.localizedDescription)")
                    } else {
                        print("New item saved successfully with ID: \(newDocumentId) using setData(from:)")
                        // Optionally clear fields
                        // self?.title = ""
                        // self?.dueDate = Date()
                    }
                }
            }
        } catch {
            // This catch block is for local encoding errors before the network request
            print("Error attempting to locally encode and setData(from: newItem): \(error.localizedDescription)")
            self.alertMessage = "Error preparing item for saving: \(error.localizedDescription)"
            self.showAlert = true
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

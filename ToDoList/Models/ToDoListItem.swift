// Models/ToDoListItem.swift
import Foundation

struct ToDoListItem: Codable, Identifiable {
    var id: String // We will manage this ID
    let title: String
    let dueDate: TimeInterval
    let createdDate: TimeInterval
    var isDone: Bool

    // Helper to toggle completion status
    mutating func setDone(_ state: Bool) {
        isDone = state
    }

    // Computed property to get the dictionary for Firestore fields
    // This EXCLUDES 'id' because 'id' is the document's name/path in Firestore.
    var dataForFirestore: [String: Any] {
        return [
            "title": title,
            "dueDate": dueDate,
            "createdDate": createdDate,
            "isDone": isDone
        ]
    }

    // Failable initializer for creating an instance from a Firestore document ID and data dictionary
    init?(id: String, dictionary: [String: Any]) {
        guard let title = dictionary["title"] as? String,
              let dueDate = dictionary["dueDate"] as? TimeInterval,
              let createdDate = dictionary["createdDate"] as? TimeInterval,
              let isDone = dictionary["isDone"] as? Bool else {
            // If any required field is missing or of the wrong type, initialization fails
            print("Failed to initialize ToDoListItem from dictionary. Missing or mismatched fields.")
            print("ID: \(id), Dict: \(dictionary)")
            return nil
        }
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.createdDate = createdDate
        self.isDone = isDone
    }
    
    // This initializer will be used if you need to create an item before saving to Firestore
    init(id: String, title: String, dueDate: TimeInterval, createdDate: TimeInterval, isDone: Bool) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.createdDate = createdDate
        self.isDone = isDone
    }
}

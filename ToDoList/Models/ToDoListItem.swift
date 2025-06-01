// Models/ToDoListItem.swift
import Foundation
import FirebaseFirestore // This now includes the Swift extensions

struct ToDoListItem: Codable, Identifiable {
    @DocumentID var id: String? // Firestore will populate this when reading.
                               // It's ignored by Firestore.Encoder when writing fields via setData(from:).
    let title: String
    let dueDate: TimeInterval
    let createdDate: TimeInterval
    var isDone: Bool

    // Helper to toggle completion status
    mutating func setDone(_ state: Bool) {
        isDone = state
    }
    
    // No need for dataForFirestore or manual init from dictionary if using setData(from:) and .data(as:)
    // If you need an init for previews or other non-Firestore creation:
    init(id: String? = nil, title: String, dueDate: TimeInterval, createdDate: TimeInterval, isDone: Bool) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.createdDate = createdDate
        self.isDone = isDone
    }
}

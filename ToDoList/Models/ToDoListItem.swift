// Models/ToDoListItem.swift
import Foundation
import FirebaseFirestore // For @DocumentID and Codable with Firestore

struct ToDoListItem: Codable, Identifiable {
    @DocumentID var id: String? // Firestore will populate this if not set
    let title: String
    let dueDate: TimeInterval // Store as TimeInterval (Unix timestamp)
    let createdDate: TimeInterval
    var isDone: Bool

    // Helper to toggle completion status
    mutating func setDone(_ state: Bool) {
        isDone = state
    }
}

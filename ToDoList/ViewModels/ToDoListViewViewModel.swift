// ViewModels/ToDoListViewViewModel.swift
import Foundation

class ToDoListViewViewModel: ObservableObject {
    @Published var showingNewItemView = false
    // We'll add logic to fetch and display items later

    // userId will be passed from ToDoListView
    private let userId: String

    init(userId: String) {
        self.userId = userId
        // Initialize fetching of to-do items here for this user
        // fetchToDoItems()
    }

    // func fetchToDoItems() { ... }
    // func deleteToDoItem(id: String) { ... }
    // func toggleIsDone(item: ToDoListItem) { ... }
}

// Views/ToDoListView.swift
import SwiftUI
import FirebaseFirestore

struct ToDoListView: View {
    // Initialize the ViewModel with the userId
    @StateObject var viewModel: ToDoListViewViewModel

    init(userId: String) {
        // Initialize the StateObject with the specific userId
        _viewModel = StateObject(wrappedValue: ToDoListViewViewModel(userId: userId))
    }

    var body: some View {
        NavigationView {
            VStack {
                // Placeholder for the list of To-Do items
                // Need to replace this with a List that iterates over items fetched by the ViewModel
                List {
                    Text("Task 1 (Placeholder)")
                    Text("Task 2 (Placeholder)")
                    // ForEach(items) { item in /* ToDoListItemView(item: item) */ }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("My To-Dos") // Title for this screen
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.showingNewItemView = true // Action to show the sheet
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundStyle(LinearGradient(colors: [.cyan, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingNewItemView) {
                NewItemView() // Present the NewItemView as a sheet
            }
        }
    }
}

#Preview {
    // Provide a dummy userId for the preview.
    // In a real app, ContentView handles providing the actual userId.
    ToDoListView(userId: "previewUser123")
}

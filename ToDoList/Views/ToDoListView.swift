// Views/ToDoListView.swift
import SwiftUI

struct ToDoListView: View {
    @StateObject var viewModel: ToDoListViewViewModel
    @Environment(\.colorScheme) var colorScheme
    
    private let userId: String

    init(userId: String) {
        self.userId = userId
        _viewModel = StateObject(wrappedValue: ToDoListViewViewModel(userId: userId))
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.items.isEmpty {
                    emptyStateView
                } else {
                    List {
                        ForEach(viewModel.items) { item in
                            ToDoListItemView(item: item, userId: self.userId)
                        }
                        // --- ADDED MODIFIER ---
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("My To-Dos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.showingNewItemView = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundStyle(LinearGradient(colors: [.cyan, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                    }
                }
                // --- Optional: Add EditButton for bulk delete mode ---
                // ToolbarItem(placement: .navigationBarLeading) {
                //     EditButton()
                // }
            }
            .sheet(isPresented: $viewModel.showingNewItemView) {
                NewItemView()
            }
        }
    }
    
    // --- NEW FUNCTION ---
    private func deleteItems(at offsets: IndexSet) {
        // The 'offsets' IndexSet tells us which rows the user swiped on.
        // We need to map these offsets to the actual item IDs from our viewModel.items array.
        for index in offsets {
            let itemToDelete = viewModel.items[index] // Get the item at that index
            if let itemId = itemToDelete.id { // Ensure item has an ID
                viewModel.delete(itemId: itemId)
            } else {
                print("Error: Attempted to delete an item without an ID at index \(index).")
            }
        }
    }
    
    @ViewBuilder
    private var emptyStateView: some View {
        // ... (emptyStateView remains the same)
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "list.bullet.clipboard")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(colorScheme == .dark ? .gray.opacity(0.6) : .gray.opacity(0.8))
            Text("No Tasks Yet!")
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.7))
            Text("Tap the '+' button to add your first to-do item.")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .gray : .secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// Previews remain the same
#Preview("Light Mode - With Items (Direct Set)") {
    let view = ToDoListView(userId: "previewWithData")
    view.viewModel.items = [
        ToDoListItem(id: "1", title: "Preview Task 1", dueDate: Date().addingTimeInterval(86400).timeIntervalSince1970, createdDate: Date().timeIntervalSince1970, isDone: false),
        ToDoListItem(id: "2", title: "Preview Task 2 - Done", dueDate: Date().addingTimeInterval(86400*2).timeIntervalSince1970, createdDate: Date().timeIntervalSince1970-86400, isDone: true)
    ]
    return view
        .preferredColorScheme(.light)
}

#Preview("Light Mode - Empty") {
    ToDoListView(userId: "previewUserEmpty")
        .preferredColorScheme(.light)
}

// Views/ToDoListView.swift
import SwiftUI

struct ToDoListView: View {
    @StateObject var viewModel: ToDoListViewViewModel
    @Environment(\.colorScheme) var colorScheme

    init(userId: String) {
        _viewModel = StateObject(wrappedValue: ToDoListViewViewModel(userId: userId))
    }

    var body: some View {
        // The NavigationView is now part of the TabView in ContentView,
        // so we might not need a new one here.
        // If this ToDoListView is always presented within ContentView's TabView > NavigationView,
        // then this NavigationView can be removed, and .navigationTitle/.toolbar will apply to
        // the NavigationView provided by the TabView structure.
        NavigationView {
            VStack {
                if viewModel.items.isEmpty {
                    emptyStateView
                } else {
                    List {
                        ForEach(viewModel.items) { item in
                            // We will replace this with ToDoListItemView soon
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.title)
                                        .font(.headline)
                                    Text("Due: \(Date(timeIntervalSince1970: item.dueDate).formatted(date: .abbreviated, time: .omitted))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                // Placeholder for checkbox
                                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(item.isDone ? .green : .gray)
                            }
                            .padding(.vertical, 4)
                        }
                        // We'll add .onDelete modifier here later for deleting items
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
            }
            .sheet(isPresented: $viewModel.showingNewItemView) {
                NewItemView()
            }
        }
    }
    
    // A helper view for the empty state
    @ViewBuilder
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer() // Pushes content to center
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
            Spacer() // Pushes content to center
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview("Light Mode - With Items") {
    // For preview, we can inject a ViewModel with dummy data
    let vm = ToDoListViewViewModel(userId: "previewUser123")
    vm.items = [
        ToDoListItem(id: "1", title: "Buy groceries", dueDate: Date().timeIntervalSince1970 + 86400, createdDate: Date().timeIntervalSince1970, isDone: false),
        ToDoListItem(id: "2", title: "Finish report", dueDate: Date().timeIntervalSince1970 + (86400*2), createdDate: Date().timeIntervalSince1970 - 86400, isDone: true),
        ToDoListItem(id: "3", title: "Call mom", dueDate: Date().timeIntervalSince1970, createdDate: Date().timeIntervalSince1970 - (86400*2), isDone: false)
    ]
    return ToDoListView(userId: "previewUser123")
        .environmentObject(vm)
}

#Preview("Light Mode - Empty") {
    ToDoListView(userId: "previewUserEmpty")
        .preferredColorScheme(.light)
}

#Preview("Dark Mode - Empty") {
    ToDoListView(userId: "previewUserEmptyDark")
        .preferredColorScheme(.dark)
}

// To properly preview with items:
struct ToDoListView_WithItems_Preview: PreviewProvider {
    static var previews: some View {
        let viewModel = ToDoListViewViewModel(userId: "previewWithItems")
        viewModel.items = [
            ToDoListItem(id: "1", title: "Walk the dog", dueDate: Date().addingTimeInterval(86400).timeIntervalSince1970, createdDate: Date().timeIntervalSince1970, isDone: false),
            ToDoListItem(id: "2", title: "Read a book", dueDate: Date().addingTimeInterval(86400 * 2).timeIntervalSince1970, createdDate: Date().timeIntervalSince1970 - 86400, isDone: true)
        ]
        // Create a ToDoListView instance and then modify its viewModel's items.
        // This is tricky because @StateObject re-initializes.
        // The best way for complex previews is to have the View accept the ViewModel as a parameter.
        // However, our current structure _viewModel = StateObject(wrappedValue: ...) is standard.
        // For now, testing with Firestore emulator or real data is more reliable for item lists.
        // The Empty state previews will work fine.
        
        // A simple way to make the preview work with data (though it bypasses the real VM init for the preview instance):
        let view = ToDoListView(userId: "previewWithData")
        view.viewModel.items = [ // Directly set items on the preview's VM instance
            ToDoListItem(id: "1", title: "Preview Task 1", dueDate: Date().addingTimeInterval(86400).timeIntervalSince1970, createdDate: Date().timeIntervalSince1970, isDone: false),
            ToDoListItem(id: "2", title: "Preview Task 2 - Done", dueDate: Date().addingTimeInterval(86400*2).timeIntervalSince1970, createdDate: Date().timeIntervalSince1970-86400, isDone: true)
        ]
        return view
            .preferredColorScheme(.light)
            .previewDisplayName("Light Mode - With Items (Direct Set)")
    }
}

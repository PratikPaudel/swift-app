// Views/ToDoListItemView.swift
import SwiftUI

struct ToDoListItemView: View {
    // This ViewModel will handle actions for this specific item
    @StateObject var viewModel: ToDoListItemViewViewModel
    let item: ToDoListItem // The data to display

    @Environment(\.colorScheme) var colorScheme

    // Initialize with the item and the userId to create its ViewModel
    init(item: ToDoListItem, userId: String) {
        self.item = item
        // Each row (ToDoListItemView) gets its own ViewModel instance
        // We pass the userId so the item's ViewModel knows whose data to update.
        _viewModel = StateObject(wrappedValue: ToDoListItemViewViewModel(userId: userId))
    }

    var body: some View {
        HStack(spacing: 15) {
            // Checkbox Image - now tappable
            Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundColor(item.isDone ? .green : (colorScheme == .dark ? .gray.opacity(0.7) : .gray))
                .onTapGesture {
                    viewModel.toggleIsDone(item: item)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .strikethrough(item.isDone, color: colorScheme == .dark ? .gray : .secondary)
                    .foregroundColor(item.isDone ? (colorScheme == .dark ? .gray : .secondary) : (colorScheme == .dark ? .white : .primary))

                Text("Due: \(formattedDueDate)")
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(dueDateColor)
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }

    private var formattedDueDate: String {
        let date = Date(timeIntervalSince1970: item.dueDate)
        if Calendar.current.isDateInToday(date) { return "Today" }
        else if Calendar.current.isDateInTomorrow(date) { return "Tomorrow" }
        else if Calendar.current.isDateInYesterday(date) { return "Yesterday" }
        else { return date.formatted(date: .abbreviated, time: .omitted) }
    }
    
    private var dueDateColor: Color {
        let todayStart = Calendar.current.startOfDay(for: Date())
        let dueDateStart = Calendar.current.startOfDay(for: Date(timeIntervalSince1970: item.dueDate))

        if item.isDone { return colorScheme == .dark ? .gray.opacity(0.6) : .gray }
        else if dueDateStart < todayStart { return .red }
        else if dueDateStart == todayStart { return colorScheme == .dark ? .orange.opacity(0.9) : .orange }
        else { return colorScheme == .dark ? .gray.opacity(0.8) : .secondary }
    }
}

// Updated Previews for ToDoListItemView
#Preview("Incomplete Task - Light (Interactive)") {
    ToDoListItemView(
        item: ToDoListItem(
            id: "1", title: "Interactive Task",
            dueDate: Date().addingTimeInterval(86400).timeIntervalSince1970,
            createdDate: Date().timeIntervalSince1970, isDone: false
        ),
        userId: "previewUser" // Dummy userId for preview
    )
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Completed Task - Dark (Interactive)") {
    ToDoListItemView(
        item: ToDoListItem(
            id: "2", title: "Completed Interactive",
            dueDate: Date().addingTimeInterval(-86400).timeIntervalSince1970,
            createdDate: Date().timeIntervalSince1970 - (86400 * 2), isDone: true
        ),
        userId: "previewUser"
    )
    .padding()
    .background(Color.black.opacity(0.8))
    .preferredColorScheme(.dark)
}

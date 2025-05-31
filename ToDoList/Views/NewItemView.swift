// Views/NewItemView.swift
import SwiftUI

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewViewModel()
    @Environment(\.dismiss) var dismiss // To dismiss the sheet programmatically
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView { // Optional: if we want a navigation bar within the sheet
            VStack(alignment: .leading, spacing: 20) {
                Text("New Task")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .padding(.top)

                // Form for input
                VStack(spacing: 20) {
                    // Title TextField
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(colorScheme == .dark ? Color.gray.opacity(0.9) : .secondary)
                        
                        TextField("Enter task title", text: $viewModel.title)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(colorScheme == .dark ? Color.black.opacity(0.2) : Color(UIColor.systemGray6))
                            )
                            .foregroundStyle(colorScheme == .dark ? .white : .primary)
                    }

                    // Due Date Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Due Date")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(colorScheme == .dark ? Color.gray.opacity(0.9) : .secondary)

                        DatePicker("", selection: $viewModel.dueDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .labelsHidden()
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(colorScheme == .dark ? Color.black.opacity(0.2) : Color(UIColor.systemGray6))
                            )
                    }
                }
                
                // Save Button
                AuthButton(title: "Save Task", iconName: "checkmark.circle.fill") {
                    if viewModel.canSave {
                        viewModel.save()
                        dismiss() // Dismiss the sheet after attempting to save
                    } else {
                        // viewModel.canSave already sets alertMessage, so trigger alert
                        viewModel.showAlert = true
                    }
                }
                .padding(.top)

                Spacer() // Pushes content to the top
            }
            .padding()
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { // Add a toolbar to the NavigationView within the sheet
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(LinearGradient(colors: [.cyan, .blue], startPoint: .leading, endPoint: .trailing))
                }
            }
        }
    }
}

#Preview("Dark NewItemView") {
    NewItemView()
        .preferredColorScheme(.dark)
}
#Preview("Light NewItemView") {
    NewItemView()
        .preferredColorScheme(.light)
}

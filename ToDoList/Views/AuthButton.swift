// AuthButton.swift
import SwiftUI

struct AuthButton: View {
    let title: String
    let iconName: String? // Optional icon
    let action: () -> Void

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                
                if let iconName = iconName {
                    Image(systemName: iconName)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .foregroundColor(.white) // Text color on button
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [Color.cyan, Color.blue],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(14)
            .shadow(
                color: colorScheme == .dark ?
                    Color.cyan.opacity(0.4) : Color.blue.opacity(0.3),
                radius: 15,
                x: 0,
                y: 8
            )
        }
    }
}

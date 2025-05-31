// HeaderView.swift
import SwiftUI

struct HeaderView: View {
    let title: String
    let subtitle: String
    let iconName: String = "checkmark.circle.fill" // Default icon
    let showIcon: Bool // To control if the icon section is displayed

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 16) {
            if showIcon {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: colorScheme == .dark ?
                                    [Color.cyan.opacity(0.3), Color.blue.opacity(0.2)] :
                                    [Color.blue.opacity(0.1), Color.cyan.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.cyan, Color.blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(
                    color: colorScheme == .dark ?
                        Color.cyan.opacity(0.3) : Color.blue.opacity(0.2),
                    radius: 20,
                    x: 0,
                    y: 10
                )
                .padding(.bottom, 10) // Space between icon and text
            }

            Text(title)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(
                    colorScheme == .dark ?
                        Color.white : Color.primaryText // Use primaryText for better light mode
                )

            Text(subtitle)
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .foregroundStyle(
                    colorScheme == .dark ?
                        Color.gray.opacity(0.8) : Color.secondaryText // Use secondaryText
                )
                .multilineTextAlignment(.center)
        }
    }
}

// Define Color extensions for semantic colors (optional but good practice)
extension Color {
    static var primaryText: Color {
        // Example: Using system primary color for text
        // In a real app, you might define specific hex values
        return Color.primary
    }
    static var secondaryText: Color {
        return Color.secondary
    }
}


#Preview("Dark Header") {
    HeaderView(title: "Sample Title", subtitle: "This is a sample subtitle for the header.", showIcon: true)
        .padding()
        .background(Color(red: 0.05, green: 0.08, blue: 0.12))
        .preferredColorScheme(.dark)
}

#Preview("Light Header") {
    HeaderView(title: "Sample Title", subtitle: "This is a sample subtitle for the header.", showIcon: true)
        .padding()
        .background(Color(red: 0.98, green: 0.98, blue: 1.0))
        .preferredColorScheme(.light)
}

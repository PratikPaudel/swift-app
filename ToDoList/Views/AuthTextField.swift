// AuthTextField.swift
import SwiftUI

struct AuthTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let iconName: String
    var isSecure: Bool = false
    @Binding var isSecureVisible: Bool // Use regular Bool, not optional for direct use
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    var autocapitalization: UITextAutocapitalizationType = .sentences
    var disableAutocorrection: Bool = false

    @Environment(\.colorScheme) var colorScheme

    // Initializer for non-secure fields
    init(title: String, placeholder: String, text: Binding<String>, iconName: String,
         isSecure: Bool = false, // Default to false
         keyboardType: UIKeyboardType = .default, textContentType: UITextContentType? = nil,
         autocapitalization: UITextAutocapitalizationType = .sentences, disableAutocorrection: Bool = false) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.iconName = iconName
        self.isSecure = isSecure
        self._isSecureVisible = .constant(false) // Dummy binding, not used
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.autocapitalization = autocapitalization
        self.disableAutocorrection = disableAutocorrection
    }

    // Initializer for secure fields that need visibility toggle
    init(title: String, placeholder: String, text: Binding<String>, iconName: String,
         isSecure: Bool, isSecureVisible: Binding<Bool>, // isSecure must be true
         textContentType: UITextContentType? = nil) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.iconName = iconName
        self.isSecure = isSecure
        self._isSecureVisible = isSecureVisible
        self.textContentType = textContentType
        // Other params like keyboardType, autocapitalization are less relevant for passwords
    }


    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(
                    colorScheme == .dark ?
                        Color.gray.opacity(0.9) : Color.secondaryText
                )
            
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .foregroundStyle(
                        colorScheme == .dark ?
                            Color.cyan.opacity(0.7) : Color.blue.opacity(0.6)
                    )
                    .frame(width: 20)
                
                Group {
                    if isSecure {
                        if isSecureVisible {
                            TextField(placeholder, text: $text)
                                .textContentType(textContentType)
                        } else {
                            SecureField(placeholder, text: $text)
                                .textContentType(textContentType)
                        }
                    } else {
                        TextField(placeholder, text: $text)
                            .keyboardType(keyboardType)
                            .textContentType(textContentType)
                            .autocapitalization(autocapitalization)
                            .disableAutocorrection(disableAutocorrection)
                    }
                }
                .foregroundStyle(
                    colorScheme == .dark ?
                        Color.white : Color.primaryText
                )
                
                if isSecure {
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isSecureVisible.toggle()
                        }
                    } label: {
                        Image(systemName: isSecureVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundStyle(
                                colorScheme == .dark ?
                                    Color.gray.opacity(0.7) : Color.gray.opacity(0.6)
                            )
                            .frame(width: 20)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        colorScheme == .dark ?
                            Color.black.opacity(0.3) : Color.white
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(
                                colorScheme == .dark ?
                                    Color.gray.opacity(0.3) : Color.gray.opacity(0.2),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(
                color: colorScheme == .dark ?
                    Color.black.opacity(0.3) : Color.gray.opacity(0.1),
                radius: 8,
                x: 0,
                y: 2
            )
        }
    }
}

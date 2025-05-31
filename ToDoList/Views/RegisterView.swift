// RegisterView.swift
import SwiftUI

struct RegisterView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode // To dismiss this view

    var body: some View {
        ZStack {
            LinearGradient(
                colors: colorScheme == .dark ?
                    [Color(red: 0.05, green: 0.08, blue: 0.12), Color(red: 0.12, green: 0.15, blue: 0.20)] :
                    [Color(red: 0.98, green: 0.98, blue: 1.0), Color(red: 0.95, green: 0.96, blue: 0.98)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {
                    Spacer(minLength: 20)

                    HeaderView(
                        title: "Create Account",
                        subtitle: "Get started by creating your new account",
                        showIcon: true // Or false/different icon if desired for registration
                    )
                    .padding(.bottom, 20)

                    VStack(spacing: 20) {
                        AuthTextField(
                            title: "Full Name",
                            placeholder: "Enter your full name",
                            text: $fullName,
                            iconName: "person.fill",
                            autocapitalization: .words
                        )
                        
                        AuthTextField(
                            title: "Email Address",
                            placeholder: "Enter your email",
                            text: $email,
                            iconName: "envelope.fill",
                            keyboardType: .emailAddress,
                            textContentType: .emailAddress,
                            autocapitalization: .none,
                            disableAutocorrection: true
                        )
                        
                        AuthTextField(
                            title: "Password",
                            placeholder: "Create a password",
                            text: $password,
                            iconName: "lock.fill",
                            isSecure: true,
                            isSecureVisible: $isPasswordVisible,
                            textContentType: .newPassword
                        )
                        
                        AuthTextField(
                            title: "Confirm Password",
                            placeholder: "Confirm your password",
                            text: $confirmPassword,
                            iconName: "lock.shield.fill",
                            isSecure: true,
                            isSecureVisible: $isConfirmPasswordVisible,
                            textContentType: .newPassword
                        )
                    }
                    .padding(.horizontal, 4)

                    AuthButton(title: "Sign Up", iconName: "arrow.right.circle.fill") {
                        print("Registering: \(fullName), \(email), Pass: \(password), Confirm: \(confirmPassword)")
                        // Add validation logic here
                    }
                    .padding(.top, 16)

                    Spacer(minLength: 40)

                    HStack(spacing: 6) {
                        Text("Already have an account?")
                            .font(.system(size: 16, design: .rounded))
                            .foregroundStyle(
                                colorScheme == .dark ?
                                    Color.gray.opacity(0.8) : Color.secondaryText
                            )
                        
                        Button {
                            presentationMode.wrappedValue.dismiss() // Go back to LoginView
                        } label: {
                            Text("Sign In")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.cyan, Color.blue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        }
                    }
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 32)
            }
        }
        .navigationBarHidden(true) // Keep custom UI, RegisterView is pushed
    }
}


#Preview("Dark Mode Register") {
    NavigationView { // Needed for presentationMode to work in preview
        RegisterView()
    }
    .preferredColorScheme(.dark)
}

#Preview("Light Mode Register") {
    NavigationView {
        RegisterView()
    }
    .preferredColorScheme(.light)
}

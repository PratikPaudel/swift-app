// LoginView.swift
import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView { // Essential for NavigationLink to work
            ZStack {
                // Adaptive Background
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
                        Spacer(minLength: 20) // Top spacing

                        // Use HeaderView
                        HeaderView(
                            title: "Welcome Back",
                            subtitle: "Sign in to continue managing your tasks",
                            showIcon: true
                        )
                        .padding(.bottom, 20) // Spacing after header

                        // Input Fields Section
                        VStack(spacing: 20) {
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
                                placeholder: "Enter your password",
                                text: $password,
                                iconName: "lock.fill",
                                isSecure: true,
                                isSecureVisible: $isPasswordVisible,
                                textContentType: .password
                            )
                        }
                        .padding(.horizontal, 4) // Slight inset for the fields group
                    
                        // Forgot Password Link
                        HStack {
                            Spacer()
                            Button("Forgot Password?") {
                                print("Forgot password tapped")
                            }
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.cyan, Color.blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        }
                        .padding(.horizontal, 4)
                        .padding(.top, 4)

                        // Login Button
                        AuthButton(title: "Sign In", iconName: "arrow.right") {
                            print("Logging in with email: \(email) and password: \(password)")
                        }
                        .padding(.top, 16)

                        Spacer(minLength: 40) // Space before sign up option

                        // Sign Up Option
                        HStack(spacing: 6) {
                            Text("Don't have an account?")
                                .font(.system(size: 16, design: .rounded))
                                .foregroundStyle(
                                    colorScheme == .dark ?
                                        Color.gray.opacity(0.8) : Color.secondaryText
                                )
                            
                            NavigationLink(destination: RegisterView()) {
                                Text("Sign Up")
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
                        .padding(.bottom, 30) // Bottom spacing
                    }
                    .padding(.horizontal, 32) // Main horizontal padding for the content
                }
            }
            .navigationBarHidden(true) // Hide the default navigation bar
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Good practice for this type of flow
    }
}


#Preview("Dark Mode Login") {
    LoginView()
        .preferredColorScheme(.dark)
}

#Preview("Light Mode Login") {
    LoginView()
        .preferredColorScheme(.light)
}

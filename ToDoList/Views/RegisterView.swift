// RegisterView.swift
import SwiftUI
import FirebaseAuth // Make sure this is imported

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()
    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode

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
                    Spacer(minLength: 60)

                    HeaderView(
                        title: "Create Account",
                        subtitle: "Get started by creating your new account",
                        iconName: "person.crop.circle.fill.badge.plus",
                        showIcon: true
                    )
                    .padding(.bottom, 20)

                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(.red)
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 4)
                    }

                    VStack(spacing: 20) {
                        AuthTextField(
                            title: "Full Name",
                            placeholder: "Enter your full name",
                            text: $viewModel.name,
                            iconName: "person.fill",
                            autocapitalization: .words
                        )
                        
                        AuthTextField(
                            title: "Email Address",
                            placeholder: "Enter your email",
                            text: $viewModel.email,
                            iconName: "envelope.fill",
                            keyboardType: .emailAddress,
                            textContentType: .emailAddress,
                            autocapitalization: .none,
                            disableAutocorrection: true
                        )
                        
                        AuthTextField(
                            title: "Password",
                            placeholder: "Create a password",
                            text: $viewModel.password,
                            iconName: "lock.fill",
                            isSecure: true,
                            isSecureVisible: $isPasswordVisible,
                            textContentType: .newPassword
                        )
                        
                        AuthTextField(
                            title: "Confirm Password",
                            placeholder: "Confirm your password",
                            text: $viewModel.confirmPassword,
                            iconName: "lock.shield.fill",
                            isSecure: true,
                            isSecureVisible: $isConfirmPasswordVisible,
                            textContentType: .newPassword
                        )
                    }
                    .padding(.horizontal, 4)

                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding(.top, 16)
                            .tint(colorScheme == .dark ? .white : .blue)
                    } else {
                        AuthButton(
                            title: "Sign Up",
                            iconName: "arrow.right.circle.fill"
                        ) {
                            viewModel.register()
                        }
                        .padding(.top, 16)
                    }

                    Spacer(minLength: 40)

                    HStack(spacing: 6) {
                        Text("Already have an account?")
                            .font(.system(size: 16, design: .rounded))
                            .foregroundStyle(
                                colorScheme == .dark ?
                                    Color.gray.opacity(0.8) : Color.secondary
                            )
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
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
        .navigationBarHidden(true)
    }
}


#Preview("Dark Mode Register") {
    NavigationView { RegisterView() }
        .preferredColorScheme(.dark)
}

#Preview("Light Mode Register") {
    NavigationView { RegisterView() }
        .preferredColorScheme(.light)
}

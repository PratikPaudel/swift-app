// LoginView.swift
import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    @State private var isPasswordVisible: Bool = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
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
                            title: "Welcome Back",
                            subtitle: "Sign in to continue managing your tasks",
                            iconName: "checkmark.circle.fill",
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
                                placeholder: "Enter your password",
                                text: $viewModel.password,
                                iconName: "lock.fill",
                                isSecure: true,
                                isSecureVisible: $isPasswordVisible,
                                textContentType: .password
                            )
                        }
                        .padding(.horizontal, 4)
                        HStack {
                            Spacer()
                            Button("Forgot Password?") {
                                print("Forgot password tapped")
                                // viewModel.forgotPassword() // Future implementation
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

                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding(.top, 16)
                                .tint(colorScheme == .dark ? .white : .blue)
                        } else {
                            AuthButton(
                                title: "Sign In",
                                iconName: "arrow.right"
                            ) {
                                viewModel.login()
                            }
                            .padding(.top, 16)
                        }

                        Spacer(minLength: 40)

                        HStack(spacing: 6) {
                            Text("Don't have an account?")
                                .font(.system(size: 16, design: .rounded))
                                .foregroundStyle(
                                    colorScheme == .dark ?
                                        Color.gray.opacity(0.8) : Color.secondary
                                )
                            
                            NavigationLink(destination: RegisterView()) { //
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
                        .padding(.bottom, 30)
                    }
                    .padding(.horizontal, 32)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
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

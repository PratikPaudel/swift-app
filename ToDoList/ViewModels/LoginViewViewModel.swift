// ViewModels/LoginViewViewModel.swift
import Foundation
import FirebaseAuth

class LoginViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isLoading = false // To show a loading indicator if desired

    init() {}

    func login() {
        guard validate() else {
            return
        }
        isLoading = true
        errorMessage = "" // Clear previous errors

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async { // Ensure UI updates are on the main thread
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = "Login Failed: \(error.localizedDescription)"
                    print("Login Error: \(error.localizedDescription)")
                    return
                }

                if let user = result?.user {
                    print("User logged in successfully: \(user.uid)")
                    // Here you would typically trigger navigation to the main app content
                    // For now, we'll just clear the error message.
                    // You might want to set a @Published var isLoggedIn = true here.
                    self?.errorMessage = "" // Clear if successful, or set a success message temporarily
                } else {
                    self?.errorMessage = "Login Failed: Unknown error."
                }
            }
        }
    }

    private func validate() -> Bool {
        errorMessage = "" // Clear previous errors
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }

        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter a valid email address."
            return false
        }
        return true
    }
}

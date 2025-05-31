// ViewModels/RegisterViewViewModel.swift
import Foundation
import FirebaseAuth
import FirebaseFirestore // For Firestore database

class RegisterViewViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = "" // For UI validation

    @Published var errorMessage = ""
    @Published var isLoading = false

    init() {}

    func register() {
        guard validate() else {
            return
        }
        isLoading = true
        errorMessage = ""

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }

            DispatchQueue.main.async { // UI updates on main thread
                if let error = error {
                    self.isLoading = false
                    self.errorMessage = "Registration Failed: \(error.localizedDescription)"
                    print("Registration Error: \(error.localizedDescription)")
                    return
                }

                guard let userId = result?.user.uid else {
                    self.isLoading = false
                    self.errorMessage = "Registration Failed: Could not get user ID."
                    return
                }

                // If Firebase user creation is successful, insert user record into Firestore
                self.insertUserRecord(id: userId)
            }
        }
    }

    private func insertUserRecord(id: String) {
        let newUser = User(
            id: id,
            name: name,
            email: email,
            joined: Date().timeIntervalSince1970
        )

        let db = Firestore.firestore()
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary()) { [weak self] error in
                DispatchQueue.main.async { // UI updates on main thread
                    self?.isLoading = false
                    if let error = error {
                        // This error is critical as Firebase user exists but DB record failed
                        self?.errorMessage = "Failed to save user data: \(error.localizedDescription)"
                        print("Firestore Error: \(error.localizedDescription)")
                    } else {
                        print("User registered and data saved successfully: \(id)")
                        self?.errorMessage = "" // Clear if successful
                    }
                }
            }
    }

    private func validate() -> Bool {
        errorMessage = ""
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }

        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter a valid email address."
            return false
        }

        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters long."
            return false
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return false
        }

        return true
    }
}

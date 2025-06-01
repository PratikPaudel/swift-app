// ViewModels/ProfileViewViewModel.swift
import Foundation
import FirebaseAuth
import FirebaseFirestore

class ProfileViewViewModel: ObservableObject {
    @Published var user: User? = nil // To store the fetched user data
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    init() {
        fetchUser()
    }

    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "Could not get current user ID."
            print("Error: Current user ID is nil in ProfileViewViewModel.")
            return
        }

        isLoading = true
        errorMessage = nil
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            DispatchQueue.main.async { // Ensure UI updates on main thread
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = "Failed to fetch user data: \(error.localizedDescription)"
                    print("Error fetching user: \(error.localizedDescription)")
                    return
                }

                guard let data = snapshot?.data() else {
                    self?.errorMessage = "User document does not exist or is empty."
                    print("Error: User document data is nil for userId: \(userId)")
                    return
                }

                // Manually decode the user data
                // Assuming your User struct matches the fields in Firestore
                let id = userId // We already have this
                let name = data["name"] as? String ?? "N/A"
                let email = data["email"] as? String ?? "N/A"
                let joinedTimestamp = data["joined"] as? TimeInterval ?? Date().timeIntervalSince1970

                self?.user = User(id: id, name: name, email: email, joined: joinedTimestamp)
                print("User data fetched: \(self?.user?.name ?? "Unknown")")
            }
        }
    }

    func logOut() {
        do {
            try Auth.auth().signOut()
            // The AuthStateDidChangeListener in ContentViewViewModel will automatically
            // update the app's state, causing ContentView to switch back to LoginView.
            // No need to directly manipulate currentUserId here as ContentViewViewModel handles it.
            print("User logged out successfully.")
        } catch let signOutError as NSError {
            self.errorMessage = "Error signing out: \(signOutError.localizedDescription)"
            print("Error signing out: %@", signOutError)
        }
    }
}

// ViewModels/ContentViewViewModel.swift
import Foundation
import FirebaseAuth

class ContentViewViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    private var handler: AuthStateDidChangeListenerHandle? // To store the listener handle

    init() {
        // Setup the Firebase Auth state change listener
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            // This closure is called whenever the authentication state changes
            // It's important to dispatch UI updates to the main thread
            DispatchQueue.main.async {
                // Update currentUserId based on the presence of a user and their UID
                self?.currentUserId = user?.uid ?? ""
                // For debugging:
                // print("Auth state changed. Current User ID: \(self?.currentUserId ?? "nil")")
            }
        }
    }

    // Computed property to check if a user is currently signed in
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }

    // It's good practice to remove the listener when the ViewModel is deinitialized
    // to prevent potential memory leaks or unexpected behavior.
    deinit {
        if let handler = handler {
            Auth.auth().removeStateDidChangeListener(handler)
            // print("Auth state change listener removed.")
        }
    }
}

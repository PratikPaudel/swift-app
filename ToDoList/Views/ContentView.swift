// ContentView.swift
import SwiftUI

struct ContentView: View {
    // Create and observe an instance of ContentViewViewModel
    // @StateObject ensures the ViewModel's lifecycle is tied to this ContentView
    // and it will persist across re-renders of ContentView.
    @StateObject var viewModel = ContentViewViewModel()

    var body: some View {
        // Check if a user is signed in AND their currentUserId is not empty
        // The second check ensures we wait for the listener to potentially populate the ID.
        if viewModel.isSignedIn && !viewModel.currentUserId.isEmpty {
            // User is signed in, show the main content of the app
            // We should pass the currentUserId to ToDoListView so it can fetch user-specific data
            accountView
        } else {
            // No user is signed in, show the LoginView
            LoginView()
        }
    }
    
    @ViewBuilder
    var accountView: some View {
        TabView{
            ToDoListView(userId: viewModel.currentUserId)
                .tabItem {
                Label("Home", systemImage: "house")
            }
            ProfileView()
                .tabItem {
                Label("Profile", systemImage: "person.circle")
            }
        }
    }
}

#Preview {
    ContentView()
}

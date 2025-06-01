// Views/ProfileView.swift
import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                if viewModel.isLoading {
                    ProgressView("Loading Profile...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let user = viewModel.user {
                    profileDetailsView(user: user)
                    
                    AuthButton(title: "Log Out", iconName: "rectangle.portrait.and.arrow.right") {
                        viewModel.logOut()
                    }
                    .padding(.top, 30)
                    
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    Text("Could not load profile.")
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                Spacer() // Pushes content up
            }
            .padding()
            .navigationTitle("Profile")
        }
    }

    @ViewBuilder
    private func profileDetailsView(user: User) -> some View {
        VStack(alignment: .center, spacing: 20) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(colorScheme == .dark ? .cyan.opacity(0.8) : .blue)
                .padding(.bottom, 10)

            detailRow(label: "Name", value: user.name)
            detailRow(label: "Email", value: user.email)
            detailRow(label: "Member Since", value: Date(timeIntervalSince1970: user.joined).formatted(date: .long, time: .omitted))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(colorScheme == .dark ? Color.black.opacity(0.2) : Color(UIColor.systemGray6))
        )
        .shadow(color: colorScheme == .dark ? .black.opacity(0.3) : .gray.opacity(0.15), radius: 10, x:0, y:5)
    }
    
    @ViewBuilder
    private func detailRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .gray : .secondary)
            Text(value)
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.9) : .primary)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("Profile View - Light") {
    let viewModel = ProfileViewViewModel()
    viewModel.user = User(id: "123", name: "Pratik Poudel", email: "pratik@example.com", joined: Date().timeIntervalSince1970 - (86400 * 30)) // 30 days ago
    struct ProfileView_LoadedPreview: View {
        @StateObject var vmInstance: ProfileViewViewModel
        init() {
            let vm = ProfileViewViewModel()
            vm.user = User(id: "123", name: "Test User", email: "test@example.com", joined: Date().timeIntervalSince1970 - 86400 * 30)
            vm.isLoading = false // Ensure loading is false
            _vmInstance = StateObject(wrappedValue: vm)
        }
        var body: some View {
            ProfileView().environmentObject(_vmInstance.wrappedValue)
        }
    }
    return ProfileView()
        .preferredColorScheme(.light)
}

#Preview("Profile View - Dark (Loading)") {
    let viewModel = ProfileViewViewModel()
    viewModel.isLoading = true
    // For preview:
    struct ProfileView_Loading_Preview : View {
        @StateObject var previewViewModel = ProfileViewViewModel()
        init() {
            previewViewModel.isLoading = true
        }
        var body: some View {
            ProfileView() // It will create its own VM, so we can't easily inject this loading state
                          // This preview will show the ProfileView default init state.
        }
    }
    return ProfileView()
        .preferredColorScheme(.dark)
}

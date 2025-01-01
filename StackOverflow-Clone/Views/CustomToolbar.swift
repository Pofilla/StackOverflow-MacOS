import SwiftUI

struct CustomToolbar: View {
    @Binding var searchText: String
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            // Search field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Theme.secondaryColor)
                TextField("Search questions...", text: $searchText)
                    .textFieldStyle(.plain)
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Theme.secondaryColor)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(8)
            .background(Theme.cardBackground)
            .cornerRadius(8)
            
            Spacer()
            
            // User menu
            if let user = authViewModel.currentUser {
                Menu {
                    Text("Signed in as \(user.username)")
                        .font(.caption)
                    Divider()
                    Button("Profile") { }
                    Button("Settings") { }
                    Divider()
                    Button("Sign Out") {
                        authViewModel.signOut()
                    }
                } label: {
                    HStack {
                        Text(user.username)
                            .foregroundColor(Theme.textColor)
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(Theme.primaryColor)
                    }
                }
            } else {
                Button("Sign In") {
                    authViewModel.showAuthSheet = true
                }
                .buttonStyle(Theme.buttonStyle())
            }
        }
        .padding(.horizontal)
        .frame(height: 44)
    }
} 
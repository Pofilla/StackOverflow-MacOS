import SwiftUI

struct CustomToolbar: View {
    @Binding var searchText: String
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    
    var body: some View {
        HStack(spacing: 16) {
            // Search field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Theme.secondaryColor)
                TextField("Search questions...", text: $searchText)
                    .textFieldStyle(.plain)
                    .foregroundColor(Theme.textColor)
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
            if isLoggedIn {
                Button("View Profile") {
                    print("Navigating to Profile")
                }
                .buttonStyle(Theme.buttonStyle())
            } else {
                Button("Login") {
                    print("Login button clicked!")
                    isLoggedIn = true
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                }
                .buttonStyle(Theme.buttonStyle())
            }
        }
        .padding(.horizontal)
        .frame(height: 44)
        .background(Theme.backgroundColor)
    }
} 
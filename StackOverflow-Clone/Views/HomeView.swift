import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel // Access the authentication view model

    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to the Home View!")
                    .font(.title)
                    .padding()
                    .foregroundColor(Theme.textColor) // Ensure this color adapts to both modes
                
                // Login button spanning the full width
                Button(action: {
                    authViewModel.showAuthSheet = true // Show the authentication sheet
                }) {
                    Text("Login")
                        .font(.system(size: 16, weight: .bold))
                        .padding()
                        .frame(maxWidth: .infinity) // Make the button full width
                        .background(Theme.primaryColor) // Ensure this color adapts to both modes
                        .foregroundColor(.white) // Ensure good contrast
                        .cornerRadius(8)
                }
                .padding() // Add padding around the button

                // Navigation link to ProfileView
                NavigationLink(destination: ProfileView()) {
                    Text("Go to Profile")
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }

                Spacer() // Push content to the top
            }
            .navigationTitle("Home") // Set the navigation title for HomeView
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
} 
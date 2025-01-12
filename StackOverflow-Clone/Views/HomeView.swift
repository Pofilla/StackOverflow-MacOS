import SwiftUI

struct HomeView: View {
    @State private var showLoginView = false // State variable to control LoginView visibility

    var body: some View {
        VStack {
            Text("Home View is empty.")
                .font(.title)
                .padding()

            // Text button for Login/Signup
            Button(action: {
                showLoginView.toggle() // Toggle the visibility of LoginView
            }) {
                Text("Login / Signup")
                    .font(.headline)
                    .foregroundColor(.blue) // Change color as needed
                    .underline() // Add underline to make it look like a link
            }
            .padding() // Optional padding around the button
            .sheet(isPresented: $showLoginView) {
                LoginView(isPresented: $showLoginView) // Present LoginView as a sheet
            }
        }
        .padding()
    }
}

// Preview
#Preview {
    HomeView()
} 

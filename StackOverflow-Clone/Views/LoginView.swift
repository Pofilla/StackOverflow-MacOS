import SwiftUI

struct LoginView: View {
    @Binding var isPresented: Bool // Binding to control the visibility of the LoginView
    @State private var isLogin = true // State variable to toggle between login and signup
    @State private var username = "" // State variable for username
    @State private var email = "" // State variable for email
    @State private var password = "" // State variable for password
    @State private var errorMessage: String? // State variable for error messages
    @StateObject private var socketService = SocketService() // Initialize SocketService
    @EnvironmentObject var userSession: UserSession // Add this line at the top

    var body: some View {
        VStack(spacing: 20) {
            Text(isLogin ? "Login" : "Sign Up")
                .font(.largeTitle)
                .padding()

            // Username field for signup
            if !isLogin {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .font(.system(size: 16)) // Ensure text size is legible
            }

            // Email field
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .font(.system(size: 16)) // Ensure text size is legible

            // Password field
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .font(.system(size: 16)) // Ensure text size is legible

            // Display error message if any
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, 5)
            }

            // Text button for Login/Signup
            Button(action: {
                if isLogin {
                    loginUser(email: email, password: password)
                } else {
                    signUpUser(username: username, email: email, password: password)
                }
            }) {
                Text(isLogin ? "Login" : "Sign Up")
                    .font(.headline)
                    .foregroundColor(.blue) // Change color as needed
                    .underline() // Add underline to make it look like a link
            }
            .padding(.top, 10)

            // Cancel button
            Button("Cancel") {
                isPresented = false // Close the LoginView
            }
            .padding()
            .font(.headline)
            .foregroundColor(.blue)

            // Toggle between login and signup
            Button(action: {
                isLogin.toggle() // Toggle the login/signup state
            }) {
                Text(isLogin ? "Don't have an account? Sign Up" : "Already have an account? Login")
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .underline()
            }
            .padding()
        }
        .padding()
        .frame(width: 500, height: 500) // Set fixed size for the LoginView
        .cornerRadius(12) // Rounded corners for the view
        .shadow(radius: 10) // Add shadow for depth
        .padding()
    }

    private func loginUser(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password cannot be empty"
            return
        }

        let loginRequest = LoginRequest(action: "login", email: email, password: password)

        socketService.send(loginRequest) { result in
            switch result {
            case .success(let data):
                // Handle successful login response
                if let response = try? JSONDecoder().decode(ServerResponse.self, from: data) {
                    if response.status == "success" {
                        DispatchQueue.main.async {
                            self.isPresented = false // Close the LoginView on success
                            userSession.username = response.username // Store the username in the session
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = response.message
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }

    private func signUpUser(username: String, email: String, password: String) {
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "All fields are required"
            return
        }

        let signUpRequest = SignUpRequest(action: "sign_up", username: username, email: email, password: password)

        socketService.send(signUpRequest) { result in
            switch result {
            case .success(let data):
                // Handle successful signup response
                if let response = try? JSONDecoder().decode(ServerResponse.self, from: data) {
                    if response.status == "success" {
                        DispatchQueue.main.async {
                            self.isPresented = false // Close the LoginView on success
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = response.message
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}

// Preview
#Preview {
    LoginView(isPresented: .constant(true))
}

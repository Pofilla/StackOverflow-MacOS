import SwiftUI

struct LoginView: View {
    @Binding var isPresented: Bool
    @State private var isLogin = true
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var showToast = false
    @State private var toastMessage = ""
    @StateObject private var socketService = SocketService()
    @EnvironmentObject var userSession: UserSession

    var body: some View {
        ZStack {
            Theme.backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text(isLogin ? "Welcome Back" : "Create Account")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Theme.textColor)
                    
                    Text(isLogin ? "Sign in to your account" : "Sign up for a new account")
                        .font(.system(size: 16))
                        .foregroundColor(Theme.secondaryColor)
                }
                .padding(.top, 40)

                // Form Fields
                VStack(spacing: 16) {
                    if !isLogin {
                        // Username field for signup
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Username")
                                .font(.headline)
                                .foregroundColor(Theme.darkOrange)
                            TextField("", text: $username)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding()
                                .background(Theme.cardBackground)
                                .cornerRadius(Theme.cornerRadius)
                        }
                    }

                    // Email field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.headline)
                            .foregroundColor(Theme.darkOrange)
                        TextField("", text: $email)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Theme.cardBackground)
                            .cornerRadius(Theme.cornerRadius)
                    }

                    // Password field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.headline)
                            .foregroundColor(Theme.darkOrange)
                        SecureField("", text: $password)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Theme.cardBackground)
                            .cornerRadius(Theme.cornerRadius)
                    }
                }
                .padding(.horizontal)

                // Error message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(Theme.errorColor)
                        .font(.subheadline)
                        .padding(.top, 5)
                }

                // Action Buttons
                VStack(spacing: 16) {
                    Button(action: {
                        if isLogin {
                            loginUser(email: email, password: password)
                        } else {
                            signUpUser(username: username, email: email, password: password)
                        }
                    }) {
                        Text(isLogin ? "Sign In" : "Sign Up")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(Theme.primaryButtonStyle())
                    .padding(.horizontal)
                    
                    Button(action: { isPresented = false }) {
                        Text("Cancel")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(Theme.secondaryButtonStyle())
                    .padding(.horizontal)
                }

                // Toggle between login and signup
                Button(action: { isLogin.toggle() }) {
                    Text(isLogin ? "Don't have an account? Sign Up" : "Already have an account? Sign In")
                        .font(.subheadline)
                        .foregroundColor(Theme.primaryColor)
                }
                .padding(.top, 8)

                Spacer()
            }
            .padding()
            .frame(width: 400)
            .cornerRadius(Theme.cornerRadius)
            .shadow(color: Theme.primaryColor.opacity(0.1), radius: 10)
            
            // Toast overlay
            if showToast {
                ToastView(message: toastMessage, isShowing: $showToast)
                    .position(x: 200, y: 50)
            }
        }
        .frame(width: 500, height: 600)
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
                if let response = try? JSONDecoder().decode(ServerResponse.self, from: data) {
                    if response.status == "success" {
                        DispatchQueue.main.async {
                            self.toastMessage = "Login successful!"
                            self.showToast = true
                            userSession.username = response.username
                            
                            // Delay closing the view until after the toast
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                self.isPresented = false
                            }
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
                if let response = try? JSONDecoder().decode(ServerResponse.self, from: data) {
                    if response.status == "success" {
                        DispatchQueue.main.async {
                            self.toastMessage = "Sign up successful!"
                            self.showToast = true
                            
                            // Delay closing the view until after the toast
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                self.isPresented = false
                            }
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

#Preview {
    LoginView(isPresented: .constant(true))
        .environmentObject(UserSession())
}

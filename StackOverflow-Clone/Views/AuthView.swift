import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isLogin = true
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text(isLogin ? "Login" : "Sign Up")
                .font(.title)
                .foregroundColor(Theme.darkOrange)
            
            if !isLogin {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300)
            }
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(Theme.errorColor)
                    .font(.caption)
            }
            
            Button(isLogin ? "Login" : "Sign Up") {
                if isLogin {
                    viewModel.login(email: email, password: password)
                } else {
                    viewModel.signUp(username: username, email: email, password: password)
                }
            }
            .buttonStyle(Theme.primaryButtonStyle())
            
            Button(isLogin ? "Need an account? Sign Up" : "Have an account? Login") {
                isLogin.toggle()
                viewModel.errorMessage = nil
            }
            .foregroundColor(Theme.secondaryColor)
        }
        .padding(40)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .shadow(color: Theme.primaryColor.opacity(0.1), radius: 10)
        .frame(width: 400, height: 400)
        .background(Theme.backgroundColor)
    }
} 
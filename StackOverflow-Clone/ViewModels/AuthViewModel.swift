import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var showAuthSheet = false
    @Published var isLoading = false
    
    private let apiService = APIService()
    
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let user = try await apiService.login(email: email, password: password)
                DispatchQueue.main.async {
                    self.currentUser = user
                    self.isAuthenticated = true
                    self.showAuthSheet = false
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func signUp(username: String, email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let user = try await apiService.signUp(username: username, email: email, password: password)
                DispatchQueue.main.async {
                    self.currentUser = user
                    self.isAuthenticated = true
                    self.showAuthSheet = false
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func signOut() {
        currentUser = nil
        isAuthenticated = false
    }
} 
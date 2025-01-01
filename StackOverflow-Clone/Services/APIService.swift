import Foundation

class APIService {
    // For now, we'll use mock implementations
    func login(email: String, password: String) async throws -> User {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock successful login
        return User(
            id: "user123",
            username: "testuser",
            email: email,
            reputation: 100,
            joinDate: Date(),
            isAuthenticated: true
        )
    }
    
    func signUp(username: String, email: String, password: String) async throws -> User {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock successful signup
        return User(
            id: UUID().uuidString,
            username: username,
            email: email,
            reputation: 1,
            joinDate: Date(),
            isAuthenticated: true
        )
    }
} 
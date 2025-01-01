import Foundation

struct User: Codable, Identifiable {
    let id: String
    let username: String
    let email: String
    var reputation: Int
    var joinDate: Date
    var isAuthenticated: Bool
} 
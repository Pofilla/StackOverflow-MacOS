import SwiftUI
import Combine

class UserSession: ObservableObject {
    @Published var username: String? // Store the username of the logged-in user
} 
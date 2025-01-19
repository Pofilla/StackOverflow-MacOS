import SwiftUI
import Combine

class UserSession: ObservableObject {
    @Published var username: String? {
        didSet {
            // This will trigger view updates when username changes
            objectWillChange.send()
        }
    }
    
    var isLoggedIn: Bool {
        username != nil
    }
    
    func logout() {
        username = nil
        // Add any additional cleanup here
    }
    
    // ... rest of your UserSession implementation
} 
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var userSession: UserSession
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            // Profile information
            if let username = userSession.username {
                Text("Welcome, \(username)!")
                    .font(.title)
                    .foregroundColor(Theme.primaryColor)
            }
            
            // Logout button
            Button(action: {
                // Perform logout
                userSession.username = nil
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Logout")
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        #if os(macOS)
        .frame(minWidth: 400, minHeight: 300)
        #endif
    }
}

// Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject({
                let session = UserSession()
                session.username = "John Doe"
                return session
            }())
    }
} 
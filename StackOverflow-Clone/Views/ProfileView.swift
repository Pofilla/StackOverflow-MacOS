import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userSession: UserSession

    var body: some View {
        VStack {
            if let username = userSession.username {
                Text("Welcome, \(username)!")
                    .font(.largeTitle)
                    .padding()
            } else {
                Text("No user logged in.")
                    .font(.headline)
                    .padding()
            }
        }
        .navigationTitle("Profile")
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserSession())
} 
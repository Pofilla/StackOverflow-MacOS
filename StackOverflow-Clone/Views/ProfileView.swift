import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Profile View is currently empty.") // Placeholder content
                .font(.largeTitle)
                .padding()
        }
        .navigationTitle("Profile") // Ensure the title is set to "Profile"
    }
}

#Preview {
    ProfileView()
} 
import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to the Home View!") // Placeholder text
                .font(.title)
                .padding()
                .foregroundColor(Theme.textColor) // Ensure text color adapts
        }
        .padding() // Add padding to the VStack
        .background(Theme.backgroundColor) // Ensure background adapts
        .cornerRadius(Theme.cornerRadius) // Add corner radius for consistency
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.light) // Preview in light mode
    HomeView()
        .preferredColorScheme(.dark) // Preview in dark mode
} 
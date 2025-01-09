import SwiftUI

struct LoginButtonView: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .padding()
                .frame(minWidth: 200) // Ensures a minimum width for touch targets
                .background(Theme.primaryColor)
                .foregroundColor(.white)
                .cornerRadius(8)
                .shadow(color: Theme.primaryColor.opacity(0.2), radius: 5, x: 0, y: 2)
        }
        .accessibilityLabel("Login") // Accessibility label for screen readers
        .accessibilityHint("Tap to log in to your account") // Accessibility hint
    }
}

#Preview {
    LoginButtonView(title: "Login") {
        // Action to perform when button is clicked
        print("Login button clicked!")
    }
} 
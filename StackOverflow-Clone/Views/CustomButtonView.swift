import SwiftUI

struct CustomButtonView: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .padding()
                .background(Theme.primaryColor)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

#Preview {
    CustomButtonView(title: "Click Me") {
        // Action to perform when button is clicked
        print("Button clicked!")
    }
} 
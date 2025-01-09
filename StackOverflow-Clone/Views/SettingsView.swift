import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false // Store the user's preference

    var body: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .font(.largeTitle)
                .padding()
                .foregroundColor(Theme.textColor)

            // Toggle for Dark Mode
            Toggle(isOn: $isDarkMode) {
                Text("Dark Mode")
                    .font(.headline)
                    .foregroundColor(Theme.textColor)
            }
            .padding()
            .toggleStyle(SwitchToggleStyle(tint: Theme.primaryColor))

            Spacer()
        }
        .padding()
        .background(Theme.backgroundColor)
        .cornerRadius(Theme.cornerRadius)
    }
}

#Preview {
    SettingsView()
        .preferredColorScheme(.light)
    SettingsView()
        .preferredColorScheme(.dark)
} 
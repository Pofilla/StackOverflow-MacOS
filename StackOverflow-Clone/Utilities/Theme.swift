import SwiftUI

struct Theme {
    static let primaryColor = Color(red: 244/255, green: 128/255, blue: 36/255) // Orange
    static let secondaryColor = Color(red: 255/255, green: 165/255, blue: 0/255) // Lighter Orange
    static let darkOrange = Color(red: 255/255, green: 140/255, blue: 0/255) // Darker Orange
    static let cardBackground = Color(NSColor.controlBackgroundColor) // Use NSColor for macOS
    static let textColor = Color(NSColor.labelColor) // Use NSColor for macOS
    static let accentColor = Color(red: 255/255, green: 204/255, blue: 153/255) // Light orange
    static let errorColor = Color.red // Error color
    static let backgroundColor = Color(NSColor.windowBackgroundColor) // Use NSColor for macOS
    static let cornerRadius: CGFloat = 8 // Define a default corner radius

    // Button styles
    static func buttonStyle() -> some ButtonStyle {
        return CustomButtonStyle(color: primaryColor)
    }

    static func primaryButtonStyle() -> some ButtonStyle {
        return CustomButtonStyle(color: primaryColor)
    }

    static func secondaryButtonStyle() -> some ButtonStyle {
        return CustomButtonStyle(color: secondaryColor)
    }
}

struct CustomButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 10) // Increased vertical padding for better hit target
            .frame(minWidth: 100) // Ensure a minimum width for buttons
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .fill(color)
                    .opacity(configuration.isPressed ? 0.8 : 1)
            )
            .foregroundColor(.white)
            .shadow(color: color.opacity(0.3), radius: 3, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .stroke(configuration.isPressed ? color.opacity(0.5) : color.opacity(0.3), lineWidth: 1)
            )
    }
}

struct TagStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Theme.accentColor.opacity(0.15))
            .foregroundColor(Theme.darkOrange)
            .cornerRadius(12)
    }
}

extension View {
    func tagStyle() -> some View {
        modifier(TagStyle())
    }
} 

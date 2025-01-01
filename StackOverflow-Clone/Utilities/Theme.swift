import SwiftUI

enum Theme {
    static let backgroundColor = Color(NSColor.windowBackgroundColor)
    static let cardBackground = Color(NSColor.controlBackgroundColor)
    static let primaryColor = Color(hex: "#0A95FF")  // SO's blue
    static let secondaryColor = Color.gray
    static let textColor = Color(NSColor.labelColor)
    static let darkOrange = Color(hex: "#F48024")    // SO's orange
    static let accentColor = Color(hex: "#E1ECF4")   // SO's light blue
    static let errorColor = Color.red
    static let cornerRadius: CGFloat = 6
    
    static func buttonStyle() -> CustomButtonStyle {
        CustomButtonStyle(color: primaryColor)
    }
    
    static func secondaryButtonStyle() -> CustomButtonStyle {
        CustomButtonStyle(color: secondaryColor)
    }
    
    static func primaryButtonStyle() -> CustomButtonStyle {
        CustomButtonStyle(color: primaryColor)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct CustomButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .fill(color)
                    .opacity(configuration.isPressed ? 0.8 : 1)
            )
            .foregroundColor(.white)
            .shadow(color: color.opacity(0.3), radius: 3, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
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

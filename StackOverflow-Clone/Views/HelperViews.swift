import SwiftUI

struct GlassBackground: View {
    var body: some View {
        Theme.cardBackground
            .opacity(0.8)
            .blur(radius: 8)
            .overlay(
                Theme.cardBackground
                    .opacity(0.4)
            )
    }
}

struct PillButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.system(.body, design: .rounded))
        }
        .buttonStyle(Theme.buttonStyle())
    }
}

struct BadgeView: View {
    let count: Int
    let color: Color
    let icon: String
    
    var body: some View {
        Label("\(count)", systemImage: icon)
            .font(.system(.caption, design: .rounded))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(12)
    }
} 
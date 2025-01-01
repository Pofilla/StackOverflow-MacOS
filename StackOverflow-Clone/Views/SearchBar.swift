import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onSubmit: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Theme.secondaryColor)
            
            TextField("Search questions...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .onSubmit(onSubmit)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Theme.secondaryColor)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
} 
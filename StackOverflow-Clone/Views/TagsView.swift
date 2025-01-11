import SwiftUI

struct TagsView: View {
    @EnvironmentObject private var viewModel: QuestionListViewModel

    var allTags: [String: Int] {
        var tagCounts: [String: Int] = [:]
        for question in viewModel.questions {
            for tag in question.tags {
                tagCounts[tag, default: 0] += 1
            }
        }
        return tagCounts
    }

    var filteredTags: [(String, Int)] {
        let tags = allTags.map { ($0.key, $0.value) }
            .sorted { $0.1 > $1.1 }
        
        return tags // Return all tags without filtering
    }

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 300, maximum: 400), spacing: 16)
                ],
                spacing: 16
            ) {
                if filteredTags.isEmpty {
                    VStack {
                        Spacer() // Push content to the vertical center
                        Text("No tags found")
                            .font(.largeTitle) // Increase font size
                            .foregroundColor(.gray) // Change color for better visibility
                            .multilineTextAlignment(.center) // Center the text
                        Spacer() // Push content to the vertical center
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure it takes full space
                    .background(Color.clear) // Optional: To ensure no background color interference
                } else {
                    ForEach(filteredTags, id: \.0) { tag, count in
                        TagCard(name: tag, count: count)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Tags") // Set the navigation title for TagsView
        .cornerRadius(Theme.cornerRadius)
    }
}

struct TagCard: View {
    let name: String
    let count: Int
    @State private var isPressed: Bool = false // State to track button press

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(name)
                .tagStyle()
            
            Text("Questions tagged [\(name)]")
                .font(.subheadline)
                .foregroundColor(Theme.textColor)
                .lineLimit(2)
            
            HStack {
                Text("\(count) questions")
                    .font(.caption)
                    .foregroundColor(Theme.secondaryColor)
                
                Spacer()
                
                NavigationLink(destination: FilteredQuestionsView(tag: name)) {
                    Text("View questions")
                        .font(.caption)
                        .foregroundColor(.white) // Ensure good contrast
                        .padding(8) // Add padding for touch target
                        .background(isPressed ? Color.blue : Theme.primaryColor) // Change background color on press
                        .cornerRadius(8) // Rounded corners
                        .scaleEffect(isPressed ? 0.95 : 1.0) // Scale effect for animation
                        .animation(.easeInOut(duration: 0.2), value: isPressed) // Animation for press effect
                }
                .buttonStyle(PlainButtonStyle()) // Ensure button style is consistent
                .onHover { isHovered in
                    isPressed = isHovered // Handle hover state changes
                }
                .onTapGesture {
                    isPressed = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isPressed = false // Reset pressed state after a short delay
                    }
                }
            }
        }
        .padding()
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .shadow(color: Theme.primaryColor.opacity(0.1), radius: 2)
    }
}

#Preview {
    TagsView()
        .environmentObject(QuestionListViewModel())
} 

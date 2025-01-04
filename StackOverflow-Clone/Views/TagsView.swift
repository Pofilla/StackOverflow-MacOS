import SwiftUI

struct TagsView: View {
    @EnvironmentObject private var viewModel: QuestionListViewModel
    @State private var searchText = ""
    
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
        
        if searchText.isEmpty {
            return tags
        }
        return tags.filter { $0.0.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            SearchBar(text: $searchText) {
                // Handle search submit if needed
            }
            .padding(.horizontal)
            
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: 300, maximum: 400), spacing: 16)
                    ],
                    spacing: 16
                ) {
                    if filteredTags.isEmpty {
                        Text("No tags found")
                            .foregroundColor(Theme.secondaryColor)
                            .padding()
                    } else {
                        ForEach(filteredTags, id: \.0) { tag, count in
                            TagCard(name: tag, count: count)
                        }
                    }
                }
                .padding()
            }
        }
        .background(Theme.backgroundColor)
    }
}

struct TagCard: View {
    let name: String
    let count: Int
    
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
                
                Button("View questions") {
                    // TODO: Add navigation to filtered questions
                }
                .font(.caption)
                .foregroundColor(Theme.primaryColor)
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
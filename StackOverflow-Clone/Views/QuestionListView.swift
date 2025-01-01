import SwiftUI

struct QuestionListView: View {
    @StateObject private var viewModel = QuestionListViewModel()
    @State private var showNewQuestion = false
    @State private var searchText = ""
    
    var filteredQuestions: [Question] {
        if searchText.isEmpty {
            return viewModel.questions
        }
        return viewModel.questions.filter { question in
            question.title.localizedCaseInsensitiveContains(searchText) ||
            question.body.localizedCaseInsensitiveContains(searchText) ||
            question.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar at the top
            SearchBar(text: $searchText) {
                // Handle search submit if needed
            }
            .padding()
            
            // Questions list
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredQuestions) { question in
                        QuestionRowView(question: question)
                            .background(Theme.cardBackground)
                            .cornerRadius(Theme.cornerRadius)
                            .shadow(color: Theme.primaryColor.opacity(0.1), radius: 4)
                    }
                }
                .padding()
            }
        }
        .background(Theme.backgroundColor)
        .navigationTitle("All Questions")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showNewQuestion = true }) {
                    Label("Ask Question", systemImage: "plus.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                }
                .buttonStyle(Theme.buttonStyle())
            }
        }
        .sheet(isPresented: $showNewQuestion) {
            NewQuestionView(questionsViewModel: viewModel)
        }
    }
}

struct QuestionRowView: View {
    let question: Question
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Left side stats
            VStack(spacing: 12) {
                // Votes
                VStack(spacing: 4) {
                    Text("\(question.votes)")
                        .font(.headline)
                        .foregroundColor(Theme.textColor)
                    Text("votes")
                        .font(.caption2)
                        .foregroundColor(Theme.secondaryColor)
                }
                
                // Answers count
                VStack(spacing: 4) {
                    Text("\(question.answers.count)")
                        .font(.headline)
                        .foregroundColor(hasAcceptedAnswer ? Theme.darkOrange : Theme.textColor)
                    Text("answers")
                        .font(.caption2)
                        .foregroundColor(Theme.secondaryColor)
                }
                .padding(6)
                .background(hasAcceptedAnswer ? Theme.darkOrange.opacity(0.1) : Color.clear)
                .cornerRadius(Theme.cornerRadius)
            }
            .frame(width: 70)
            
            // Question content
            VStack(alignment: .leading, spacing: 8) {
                Text(question.title)
                    .font(.headline)
                    .foregroundColor(Theme.primaryColor)
                
                Text(question.body)
                    .font(.subheadline)
                    .foregroundColor(Theme.textColor)
                    .lineLimit(2)
                
                // Tags and metadata
                HStack {
                    // Tags
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(question.tags, id: \.self) { tag in
                                Text(tag)
                                    .tagStyle()
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Author and date
                    Text("asked \(timeAgo(question.createdDate))")
                        .font(.caption)
                        .foregroundColor(Theme.secondaryColor)
                }
            }
        }
        .padding()
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private var hasAcceptedAnswer: Bool {
        question.answers.contains { $0.isAccepted }
    }
    
    private func timeAgo(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct StatView: View {
    let value: Int
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.headline)
            Text(label)
                .font(.caption2)
                .foregroundColor(Theme.secondaryColor)
        }
        .frame(width: 60)
    }
} 
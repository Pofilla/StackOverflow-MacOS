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
    @EnvironmentObject var viewModel: QuestionListViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    let question: Question
    
    var body: some View {
        NavigationLink(destination: QuestionDetailView(question: question)) {
            HStack(alignment: .top, spacing: 16) {
                // Voting controls
                VStack(spacing: 8) {
                    Button(action: { vote(.upvote) }) {
                        Image(systemName: "arrow.up")
                            .foregroundColor(userVoteType == .upvote ? Theme.primaryColor : Theme.secondaryColor)
                    }
                    
                    Text("\(question.totalVotes)")
                        .font(.headline)
                    
                    Button(action: { vote(.downvote) }) {
                        Image(systemName: "arrow.down")
                            .foregroundColor(userVoteType == .downvote ? Theme.primaryColor : Theme.secondaryColor)
                    }
                }
                .disabled(authViewModel.currentUser == nil)
                
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
                        
                        // Answer count badge
                        BadgeView(
                            count: question.answers.count,
                            color: Theme.darkOrange,
                            icon: "text.bubble"
                        )
                        
                        // Author and date
                        Text("asked \(timeAgo(question.createdDate))")
                            .font(.caption)
                            .foregroundColor(Theme.secondaryColor)
                    }
                    
                    // Add actions menu if user is author
                    if authViewModel.currentUser?.id == question.authorId {
                        Menu {
                            Button(role: .destructive, action: deleteQuestion) {
                                Label("Delete Question", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(Theme.secondaryColor)
                        }
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .padding()
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private var userVoteType: VoteType {
        guard let userId = authViewModel.currentUser?.id else { return .none }
        return question.userVotes[userId] ?? .none
    }
    
    private func vote(_ type: VoteType) {
        viewModel.vote(on: question.id, voteType: type)
    }
    
    private func deleteQuestion() {
        viewModel.deleteQuestion(question.id, authorId: question.authorId)
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

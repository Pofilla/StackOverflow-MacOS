import SwiftUI

struct QuestionListView: View {
    @EnvironmentObject private var viewModel: QuestionListViewModel
    @EnvironmentObject private var authViewModel: AuthViewModel
    @Binding var showNewQuestion: Bool
    @State private var searchText = ""
    @State private var sortOption: SortOption = .newest
    
    enum SortOption: String, CaseIterable {
        case newest = "Newest"
        case active = "Active"
        case votes = "Votes"
        case unanswered = "Unanswered"
        
        var requestValue: String {
            switch self {
            case .newest: return "date"
            case .active: return "activity"
            case .votes: return "votes"
            case .unanswered: return "unanswered"
            }
        }
    }
    
    var filteredQuestions: [Question] {
        let filtered = searchText.isEmpty ? viewModel.questions :
            viewModel.questions.filter { question in
                question.title.localizedCaseInsensitiveContains(searchText) ||
                question.body.localizedCaseInsensitiveContains(searchText) ||
                question.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        
        return sorted(filtered)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search and filter section
            VStack(spacing: 12) {
                // Search bar
                SearchBar(text: $searchText) {
                    let request = FilterQuestionsRequest(
                        action: "filter_questions",
                        searchText: searchText
                    )
                    viewModel.filterQuestions(request)
                }
                .padding(.horizontal)
                
                Divider()
                    .background(Theme.secondaryColor.opacity(0.2))
                
                // Sort options with better visual hierarchy
                HStack {
                    Text("Sort by:")
                        .font(.subheadline)
                        .foregroundColor(Theme.secondaryColor)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Button(action: {
                                    sortOption = option
                                    let request = SortQuestionsRequest(
                                        action: "sort_questions",
                                        sortBy: option.requestValue,
                                        searchText: searchText.isEmpty ? nil : searchText
                                    )
                                    viewModel.sortQuestions(request)
                                }) {
                                    Text(option.rawValue)
                                        .font(.subheadline)
                                }
                                .buttonStyle(PillButtonStyle(isSelected: sortOption == option))
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 12)
            .background(Theme.cardBackground)
            .shadow(color: Theme.primaryColor.opacity(0.05), radius: 2)
            
            // Questions list
            ScrollView {
                LazyVStack(spacing: 12) {
                    if filteredQuestions.isEmpty {
                        EmptyStateView(
                            searchText: searchText,
                            showNewQuestion: $showNewQuestion
                        )
                    } else {
                        ForEach(filteredQuestions) { question in
                            NavigationLink(destination: QuestionDetailView(question: question)) {
                                QuestionRowView(question: question)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .background(Theme.backgroundColor)
            .refreshable {
                viewModel.loadQuestions()
            }
        }
    }
    
    private func sorted(_ questions: [Question]) -> [Question] {
        switch sortOption {
        case .newest:
            return questions.sorted { $0.createdDate > $1.createdDate }
        case .active:
            return questions.sorted { $0.answers.count > $1.answers.count }
        case .votes:
            return questions.sorted { $0.totalVotes > $1.totalVotes }
        case .unanswered:
            return questions.filter { $0.answers.isEmpty }
        }
    }
}

// Helper Views
struct EmptyStateView: View {
    let searchText: String
    @Binding var showNewQuestion: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: searchText.isEmpty ? "text.bubble" : "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(Theme.secondaryColor)
            
            Text(searchText.isEmpty ? "No questions yet" : "No matching questions found")
                .font(.headline)
            
            Text(searchText.isEmpty ? "Be the first to ask a question!" : "Try a different search term or ask a new question")
                .font(.subheadline)
                .foregroundColor(Theme.secondaryColor)
                .multilineTextAlignment(.center)
            
            Button(action: { showNewQuestion = true }) {
                Label("Ask Question", systemImage: "plus.circle.fill")
                    .symbolRenderingMode(.hierarchical)
            }
            .buttonStyle(Theme.primaryButtonStyle())
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PillButtonStyle: ButtonStyle {
    let isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                isSelected ? Theme.primaryColor : Theme.cardBackground
            )
            .foregroundColor(isSelected ? .white : Theme.secondaryColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.primaryColor.opacity(0.2), lineWidth: isSelected ? 0 : 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct QuestionRowView: View {
    @EnvironmentObject var viewModel: QuestionListViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    let question: Question
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Voting controls
            VStack(spacing: 8) {
                Button(action: { vote(.upvote) }) {
                    Image(systemName: "arrow.up")
                        .foregroundColor(userVoteType == .upvote ? Theme.primaryColor : Theme.secondaryColor)
                }
                
                Text("\(question.totalVotes)")
                    .font(.headline)
                    .foregroundColor(Theme.textColor)
                
                Button(action: { vote(.downvote) }) {
                    Image(systemName: "arrow.down")
                        .foregroundColor(userVoteType == .downvote ? Theme.primaryColor : Theme.secondaryColor)
                }
            }
            .disabled(authViewModel.currentUser == nil)
            
            // Question content
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(question.title)
                        .font(.title2.bold())
                        .foregroundColor(Theme.textColor)
                    
                    Spacer()
                    
                    // Add delete menu for question author
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
                
                Text(question.body)
                    .foregroundColor(Theme.textColor)
                
                // Tags
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(question.tags, id: \.self) { tag in
                            Text(tag)
                                .tagStyle()
                        }
                    }
                }
                
                HStack {
                    // Answer count badge
                    BadgeView(
                        count: question.answers.count,
                        color: Theme.darkOrange,
                        icon: "text.bubble"
                    )
                    
                    Spacer()
                    
                    Text("asked \(timeAgo(question.createdDate))")
                        .font(.caption)
                        .foregroundColor(Theme.secondaryColor)
                }
            }
        }
        .padding()
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .shadow(color: Theme.primaryColor.opacity(0.1), radius: 2)
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

#Preview {
    QuestionListView(showNewQuestion: .constant(false))
        .environmentObject(QuestionListViewModel())
        .environmentObject(AuthViewModel())
}

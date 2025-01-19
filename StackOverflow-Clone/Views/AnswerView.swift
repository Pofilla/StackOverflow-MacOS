import SwiftUI
import Foundation

struct AnswerView: View {
    @EnvironmentObject private var viewModel: QuestionListViewModel
    @EnvironmentObject private var userSession: UserSession
    let answer: Answer
    let questionId: String
    @State private var isDeleting = false
    @State private var showDeleteConfirmation = false
    @State private var isHovering = false
    
    private var isAuthor: Bool {
        userSession.username == answer.authorId
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Author name header
            HStack {
                Text("Answer by \(answer.authorId)")
                    .font(.headline)
                    .foregroundColor(Theme.primaryColor)
                
                Spacer()
                
                // Only show delete button if user is the author
                if isAuthor {
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(isHovering ? Theme.primaryColor : Theme.secondaryColor)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onHover { hovering in
                        isHovering = hovering
                    }
                    .alert(isPresented: $showDeleteConfirmation) {
                        Alert(
                            title: Text("Confirm Deletion"),
                            message: Text("Are you sure you want to delete this answer?"),
                            primaryButton: .destructive(Text("Delete")) {
                                deleteAnswer()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            
            // Answer content
            Text(answer.body)
                .font(.body)
                .foregroundColor(Theme.textColor)
            
            // Timestamp
            HStack {
                Spacer()
                Text("answered \(timeAgo(answer.createdDate))")
                    .font(.caption)
                    .foregroundColor(Theme.secondaryColor)
            }
        }
        .padding()
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .opacity(isDeleting ? 0.6 : 1)
    }
    
    private func deleteAnswer() {
        isDeleting = true
        viewModel.deleteAnswer(
            questionId: questionId,
            answerId: answer.id,
            authorId: answer.authorId
        )
    }
    
    private func timeAgo(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// Preview
#Preview {
    let sampleAnswer = Answer(
        id: "1",
        questionId: "1",
        authorId: "Reza",  // Use a real name for testing
        body: "This is a sample answer",
        createdDate: Date(),
        votes: 0,
        isAccepted: false
    )
    
    AnswerView(answer: sampleAnswer, questionId: "1")
        .environmentObject(QuestionListViewModel())
        .padding()
        .background(Theme.backgroundColor)
}

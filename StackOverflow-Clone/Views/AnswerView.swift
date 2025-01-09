import SwiftUI
import Foundation

struct AnswerView: View {
    @EnvironmentObject private var viewModel: QuestionListViewModel
    let answer: Answer
    let questionId: String
    @State private var isDeleting = false
    @State private var showDeleteConfirmation = false
    @State private var isHovering = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(answer.body)
                .font(.body)
                .foregroundColor(Theme.textColor)
            
            HStack {
                Spacer()
                
                Text("answered \(timeAgo(answer.createdDate))")
                    .font(.caption)
                    .foregroundColor(Theme.secondaryColor)
                
                if answer.authorId == "anonymous" {
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
        }
        .padding()
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .opacity(isDeleting ? 0.6 : 1)
    }
    
    private func deleteAnswer() {
        isDeleting = true
        viewModel.deleteAnswer(answer.id, from: questionId, authorId: answer.authorId)
    }
    
    private func timeAgo(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// Preview provider
#Preview {
    let sampleAnswer = Answer(
        id: "1",
        questionId: "1",
        authorId: "anonymous",
        body: "This is a sample answer",
        createdDate: Date(),
        votes: 0,
        isAccepted: false
    )
    
    AnswerView(answer: sampleAnswer, questionId: "1")
        .environmentObject(QuestionListViewModel())
        .environmentObject(AuthViewModel())
        .padding()
        .background(Theme.backgroundColor)
} 

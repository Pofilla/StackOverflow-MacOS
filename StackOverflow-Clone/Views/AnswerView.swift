import SwiftUI
import Foundation

struct AnswerView: View {
    @EnvironmentObject private var viewModel: QuestionListViewModel
    let answer: Answer
    let questionId: String
    
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
                    Button(action: { deleteAnswer() }) {
                        Label("Delete", systemImage: "trash")
                            .font(.caption)
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func deleteAnswer() {
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
    
    return AnswerView(answer: sampleAnswer, questionId: "1")
        .environmentObject(QuestionListViewModel())
        .environmentObject(AuthViewModel())
        .padding()
        .background(Theme.backgroundColor)
} 
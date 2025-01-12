import SwiftUI
import Foundation

struct AddAnswerView: View {
    @EnvironmentObject var viewModel: QuestionListViewModel
    @Environment(\.dismiss) private var dismiss
    let questionId: String
    
    @State private var answerBody = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 16) {
            // Header with buttons
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(Theme.secondaryButtonStyle())
                
                Spacer()
                
                Text("Your Answer")
                    .font(.headline)
                    .foregroundColor(Theme.darkOrange)
                
                Spacer()
                
                Button("Post") {
                    submitAnswer()
                }
                .buttonStyle(Theme.primaryButtonStyle())
                .disabled(answerBody.isEmpty)
            }
            .padding()
            
            // Content
            VStack(spacing: 16) {
                TextEditor(text: $answerBody)
                    .frame(height: 200)
                    .padding()
                    .background(Theme.cardBackground)
                    .cornerRadius(Theme.cornerRadius)
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .padding()
            
            Spacer()
        }
        .frame(width: 600, height: 400)
        .background(Theme.backgroundColor)
    }
    
    private func submitAnswer() {
        guard !answerBody.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showError = true
            errorMessage = "Answer cannot be empty"
            return
        }
        
        let answer = Answer(
            id: UUID().uuidString,
            questionId: questionId,
            authorId: "anonymous",
            body: answerBody.trimmingCharacters(in: .whitespacesAndNewlines),
            createdDate: Date(),
            votes: 0,
            isAccepted: false
        )
        
        viewModel.addAnswer(answer, to: questionId)
        dismiss()
    }
}

#Preview {
    AddAnswerView(questionId: "1")
        .environmentObject(QuestionListViewModel())
} 

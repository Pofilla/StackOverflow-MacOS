import SwiftUI

struct QuestionDetailView: View {
    @EnvironmentObject var viewModel: QuestionListViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showAddAnswer = false
    @State private var answerBody = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    private var question: Question {
        viewModel.questions.first { $0.id == initialQuestion.id } ?? initialQuestion
    }
    
    let initialQuestion: Question
    
    init(question: Question) {
        self.initialQuestion = question
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Question section
                VStack(alignment: .leading, spacing: 12) {
                    Text(question.title)
                        .font(.title2)
                        .foregroundColor(Theme.primaryColor)
                    
                    Text(question.body)
                        .font(.body)
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
                .padding()
                .background(Theme.cardBackground)
                .cornerRadius(Theme.cornerRadius)
                
                // Answers section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("\(question.answers.count) Answers")
                            .font(.headline)
                            .foregroundColor(Theme.darkOrange)
                        
                        Spacer()
                        
                        Button(action: { showAddAnswer = true }) {
                            Label("Add Answer", systemImage: "plus.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                        }
                        .buttonStyle(Theme.buttonStyle())
                    }
                    
                    ForEach(question.answers) { answer in
                        AnswerView(answer: answer, questionId: question.id)
                    }
                }
                .padding()
            }
            .padding()
        }
        .navigationTitle("Question Details")
        .sheet(isPresented: $showAddAnswer) {
            AddAnswerSheet(questionId: question.id)
        }
    }
    
    private func timeAgo(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct AddAnswerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: QuestionListViewModel
    let questionId: String
    
    @State private var answerBody = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            // Custom toolbar
            HStack {
                Text("Add Answer")
                    .font(.title2.bold())
                    .foregroundColor(Theme.textColor)
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(Theme.secondaryButtonStyle())
                    
                    Button("Post Answer") {
                        submitAnswer()
                    }
                    .buttonStyle(Theme.primaryButtonStyle())
                    .disabled(answerBody.isEmpty)
                }
            }
            .padding()
            .background(Theme.cardBackground)
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Answer")
                            .font(.headline)
                            .foregroundColor(Theme.darkOrange)
                        
                        TextEditor(text: $answerBody)
                            .frame(minHeight: 200)
                            .padding()
                            .background(Theme.cardBackground)
                            .cornerRadius(Theme.cornerRadius)
                        
                        if showError {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                }
                .padding()
            }
        }
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
    NavigationView {
        QuestionDetailView(question: Question(
            id: "1",
            title: "Sample Question",
            body: "This is a sample question body",
            authorId: "user1",
            createdDate: Date(),
            votes: 0,
            answers: [],
            tags: ["swift", "swiftui"],
            upvotes: 0,
            downvotes: 0,
            userVotes: [:]
        ))
        .environmentObject(QuestionListViewModel())
    }
} 

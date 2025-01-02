import SwiftUI

struct NewQuestionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var questionsViewModel: QuestionListViewModel

    @State private var title = ""
    @State private var questionBody = ""
    @State private var tags = ""

    var body: some View {
        VStack {
            // Custom toolbar
            HStack {
                Text("Ask a Question")
                    .font(.title2.bold())
                    .foregroundColor(Theme.textColor)
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(Theme.secondaryButtonStyle())
                    
                    Button("Post Question") {
                        submitQuestion()
                    }
                    .buttonStyle(Theme.primaryButtonStyle())
                    .disabled(title.isEmpty || questionBody.isEmpty || tags.isEmpty)
                }
            }
            .padding()
            .background(Theme.cardBackground)
            
            // Content
            ScrollView {
                VStack(spacing: 20) {
                    // Question Title
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.headline)
                            .foregroundColor(Theme.darkOrange)
                        TextField("What's your question?", text: $title)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Theme.cardBackground)
                            .cornerRadius(Theme.cornerRadius)
                    }
                    
                    // Question Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(Theme.darkOrange)
                        TextEditor(text: $questionBody)
                            .frame(minHeight: 200)
                            .padding()
                            .background(Theme.cardBackground)
                            .cornerRadius(Theme.cornerRadius)
                    }
                    
                    // Tags
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tags")
                            .font(.headline)
                            .foregroundColor(Theme.darkOrange)
                        TextField("Add tags (separated by commas)", text: $tags)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Theme.cardBackground)
                            .cornerRadius(Theme.cornerRadius)
                        
                        if !tags.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(
                                        tags.components(separatedBy: ",")
                                            .map { $0.trimmingCharacters(in: .whitespaces) }
                                            .filter { !$0.isEmpty },
                                        id: \.self
                                    ) { tag in
                                        Text(tag)
                                            .tagStyle()
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .background(Theme.backgroundColor)
    }

    private func submitQuestion() {
        let question = Question(
            id: UUID().uuidString,
            title: title,
            body: questionBody,
            authorId: "user1", // This should come from authenticated user
            createdDate: Date(),
            votes: 0,
            answers: [],
            tags: tags.components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty },
            upvotes: 0,
            downvotes: 0,
            userVotes: [:]
        )
        questionsViewModel.addQuestion(question)
        dismiss()
    }
}

#Preview {
    NewQuestionView(questionsViewModel: QuestionListViewModel())
} 
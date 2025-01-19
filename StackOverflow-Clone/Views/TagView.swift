import SwiftUI

struct TagView: View {
    let tag: String
    @EnvironmentObject private var questionListViewModel: QuestionListViewModel
    @State private var showQuestions = false
    
    var body: some View {
        Button(action: {
            showQuestions = true
        }) {
            Text(tag)
                .tagStyle()
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showQuestions) {
            NavigationView {
                TaggedQuestionsView(tag: tag)
                    .environmentObject(questionListViewModel)
            }
            #if os(macOS)
            .frame(minWidth: 600, minHeight: 400)
            #endif
        }
    }
}

// Renamed to avoid conflicts
struct TaggedQuestionsView: View {
    let tag: String
    @EnvironmentObject private var viewModel: QuestionListViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    private var filteredQuestions: [Question] {
        viewModel.questions.filter { $0.tags.contains(tag) }
    }
    
    var body: some View {
        VStack {
            if filteredQuestions.isEmpty {
                Text("No questions found with tag '\(tag)'")
                    .foregroundColor(Theme.secondaryColor)
                    .padding()
            } else {
                List(filteredQuestions) { question in
                    NavigationLink(destination: QuestionDetailView(question: question)) {
                        TagQuestionRowView(question: question)
                    }
                }
            }
        }
        .navigationTitle("Questions tagged '\(tag)'")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct TagQuestionRowView: View {
    let question: Question
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(question.title)
                .font(.headline)
                .foregroundColor(Theme.primaryColor)
            
            Text(question.body)
                .font(.subheadline)
                .foregroundColor(Theme.textColor)
                .lineLimit(2)
            
            HStack {
                Text("Asked by \(question.authorId)")
                    .font(.caption)
                    .foregroundColor(Theme.secondaryColor)
                
                Spacer()
                
                Text("\(question.answers.count) answers")
                    .font(.caption)
                    .foregroundColor(Theme.secondaryColor)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    TagView(tag: "swift")
        .environmentObject(QuestionListViewModel())
} 
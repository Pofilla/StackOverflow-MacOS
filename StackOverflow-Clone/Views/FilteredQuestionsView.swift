import SwiftUI

struct FilteredQuestionsView: View {
    var tag: String
    @EnvironmentObject private var viewModel: QuestionListViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.questions.filter { $0.tags.contains(tag) }) { question in
                    NavigationLink(destination: QuestionDetailView(question: question)) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(question.title)
                                .font(.headline)
                                .foregroundColor(Theme.textColor)
                            
                            Text("Posted by \(question.authorId) on \(question.createdDate, formatter: dateFormatter)")
                                .font(.subheadline)
                                .foregroundColor(Theme.secondaryColor)
                            
                            Divider()
                        }
                        .padding(.vertical, 8)
                        .background(Theme.cardBackground)
                        .cornerRadius(Theme.cornerRadius)
                    }
                }
            }
            .padding()
            .background(Theme.backgroundColor)
        }
        .navigationTitle("Questions for \(tag)")
    }
}

// Date formatter for displaying question dates
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()

#Preview {
    FilteredQuestionsView(tag: "Swift")
        .environmentObject(QuestionListViewModel())
} 
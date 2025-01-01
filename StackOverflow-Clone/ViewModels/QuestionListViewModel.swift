import SwiftUI

class QuestionListViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        loadQuestions()
    }
    
    func loadQuestions() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.questions = self.getMockQuestions()
            self.isLoading = false
        }
    }
    
    func addQuestion(_ question: Question) {
        questions.insert(question, at: 0)
    }
    
    private func getMockQuestions() -> [Question] {
        return [
            Question(
                id: "1",
                title: "How to use async/await in SwiftUI?",
                body: "I'm trying to understand how to properly use async/await in SwiftUI. Can someone explain the basic concepts?",
                authorId: "user1",
                createdDate: Date().addingTimeInterval(-3600),
                votes: 10,
                answers: [],
                tags: ["swift", "swiftui", "async"]
            ),
            Question(
                id: "2",
                title: "Best practices for MVVM in SwiftUI",
                body: "What are the best practices for implementing MVVM in SwiftUI?",
                authorId: "user2",
                createdDate: Date().addingTimeInterval(-7200),
                votes: 15,
                answers: [
                    Answer(
                        id: "answer1",
                        questionId: "2",
                        authorId: "user3",
                        body: "Here's a good example...",
                        createdDate: Date(),
                        votes: 5,
                        isAccepted: true
                    )
                ],
                tags: ["swift", "swiftui", "mvvm"]
            )
        ]
    }
} 
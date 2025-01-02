import SwiftUI

class QuestionListViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let authViewModel: AuthViewModel
    
    init(authViewModel: AuthViewModel = .init()) {
        self.authViewModel = authViewModel
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
                tags: ["swift", "swiftui", "async"],
                upvotes: 7,
                downvotes: 3,
                userVotes: [:]
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
                tags: ["swift", "swiftui", "mvvm"],
                upvotes: 12,
                downvotes: 3,
                userVotes: [:]
            )
        ]
    }
    
    func deleteQuestion(_ questionId: String, authorId: String) {
        guard let currentUserId = authViewModel.currentUser?.id,
              currentUserId == authorId else { return }
        
        questions.removeAll { $0.id == questionId }
    }
    
    func addAnswer(_ answer: Answer, to questionId: String) {
        guard let index = questions.firstIndex(where: { $0.id == questionId }) else { return }
        
        // Create a new copy of the questions array
        var updatedQuestions = questions
        updatedQuestions[index].answers.append(answer)
        
        // Update the published property to trigger UI refresh
        self.questions = updatedQuestions
        
        // Force a UI update
        objectWillChange.send()
    }
    
    func deleteAnswer(_ answerId: String, from questionId: String, authorId: String) {
        guard let currentUserId = authViewModel.currentUser?.id,
              currentUserId == authorId,
              let questionIndex = questions.firstIndex(where: { $0.id == questionId }) else { return }
        
        // Create a new copy of the questions array
        var updatedQuestions = questions
        updatedQuestions[questionIndex].answers.removeAll { $0.id == answerId }
        
        // Update the published property to trigger UI refresh
        self.questions = updatedQuestions
        
        // Force a UI update
        objectWillChange.send()
    }
    
    func vote(on questionId: String, voteType: VoteType) {
        guard let currentUserId = authViewModel.currentUser?.id,
              let index = questions.firstIndex(where: { $0.id == questionId }) else { return }
        
        let previousVote = questions[index].userVotes[currentUserId] ?? .none
        
        // Remove previous vote
        switch previousVote {
        case .upvote: questions[index].upvotes -= 1
        case .downvote: questions[index].downvotes -= 1
        case .none: break
        }
        
        // Add new vote
        switch voteType {
        case .upvote: questions[index].upvotes += 1
        case .downvote: questions[index].downvotes += 1
        case .none: break
        }
        
        questions[index].userVotes[currentUserId] = voteType
    }
} 
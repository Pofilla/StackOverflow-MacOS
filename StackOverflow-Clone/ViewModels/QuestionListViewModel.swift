import SwiftUI

// Request structures
struct QuestionRequest: Codable {
    let action: String
    let question: Question?
    
    init(action: String, question: Question? = nil) {
        self.action = action
        self.question = question
    }
}

//struct ServerResponse: Codable {
//    let status: String
//    let data: [Question]?
//    let message: String?
//}

struct AnswerRequest: Codable {
    let action: String
    let answer: Answer
    let questionId: String
}

class QuestionListViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let socketService = SocketService()
    
    init() {
        print("QuestionListViewModel initialized")
        loadQuestions()
    }
    
    func loadQuestions() {
        print("⬇️ Loading questions...")
        isLoading = true
        
        let request = QuestionRequest(action: "get_questions")
        socketService.send(request) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let data):
                    do {
                        print("📦 Received data: \(String(data: data, encoding: .utf8) ?? "")")
                        let response = try JSONDecoder.shared.decode(ServerResponse.self, from: data)
                        if response.status == "success", let questions = response.data {
                            self?.questions = questions
                            print("✅ Loaded \(questions.count) questions")
                        } else {
                            print("❌ Server returned error: \(response.message ?? "Unknown error")")
                        }
                    } catch {
                        print("❌ Decoding error: \(error)")
                        self?.errorMessage = error.localizedDescription
                    }
                case .failure(let error):
                    print("❌ Network error: \(error)")
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func addQuestion(_ question: Question) {
        print("⬆️ Adding question: \(question.title)")
        let request = QuestionRequest(action: "add_question", question: question)
        
        socketService.send(request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    print("📦 Server response for add: \(String(data: data, encoding: .utf8) ?? "")")
                    let response = try JSONDecoder.shared.decode(ServerResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        if response.status == "success" {
                            print("✅ Question added successfully")
                            if let updatedQuestions = response.data {
                                self?.questions = updatedQuestions
                                print("✅ Updated questions list with \(updatedQuestions.count) questions")
                            } else {
                                self?.loadQuestions()
                            }
                        } else {
                            print("❌ Server returned error: \(response.message ?? "Unknown error")")
                            self?.errorMessage = response.message
                        }
                    }
                } catch {
                    print("❌ Decoding error: \(error)")
                    self?.errorMessage = error.localizedDescription
                }
            case .failure(let error):
                print("❌ Network error: \(error)")
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func addAnswer(_ answer: Answer, to questionId: String) {
        let request = AnswerRequest(action: "add_answer", answer: answer, questionId: questionId)
        
        socketService.send(request) { [weak self] result in
            switch result {
            case .success:
                self?.loadQuestions()  // Refresh the list
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func deleteAnswer(questionId: String, answerId: String, authorId: String) {
        print("🗑️ Deleting answer: \(answerId) from question: \(questionId)")
        
        let request = DeleteAnswerRequest(
            action: "delete_answer",
            answerId: answerId,
            questionId: questionId,
            authorId: authorId
        )
        
        socketService.send(request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder.shared.decode(ServerResponse.self, from: data)
                        if response.status == "success" {
                            print("✅ Answer deleted successfully")
                            if let updatedQuestions = response.data {
                                self?.questions = updatedQuestions
                            }
                            // Dismiss the view if needed
                            // self?.presentationMode.wrappedValue.dismiss()
                        } else {
                            print("❌ Server returned error: \(response.message ?? "Unknown error")")
                            self?.errorMessage = response.message
                        }
                    } catch {
                        print("❌ Decoding error: \(error)")
                        self?.errorMessage = error.localizedDescription
                    }
                case .failure(let error):
                    print("❌ Network error: \(error)")
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func deleteQuestion(_ questionId: String, authorId: String) {
        print("🗑️ Deleting question: \(questionId)")
        
        let request = DeleteQuestionRequest(
            action: "delete_question",
            questionId: questionId,
            authorId: authorId
        )
        
        // Send delete request to server first
        socketService.send(request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder.shared.decode(ServerResponse.self, from: data)
                    DispatchQueue.main.async {
                        if response.status == "success" {
                            print("✅ Question deleted successfully on server")
                            // Update local state with server response
                            if let updatedQuestions = response.data {
                                self?.questions = updatedQuestions
                            }
                        } else {
                            print("❌ Server returned error: \(response.message ?? "Unknown error")")
                            self?.errorMessage = response.message
                            // Refresh questions to ensure consistency
                            self?.loadQuestions()
                        }
                    }
                } catch {
                    print("❌ Decoding error: \(error)")
                    self?.errorMessage = error.localizedDescription
                    self?.loadQuestions()
                }
            case .failure(let error):
                print("❌ Failed to delete question: \(error)")
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                    self?.loadQuestions()
                }
            }
        }
    }
    
    func vote(on questionId: String, voteType: VoteType) {
        guard let index = questions.firstIndex(where: { $0.id == questionId }) else { return }
        
        switch voteType {
        case .upvote:
            questions[index].upvotes += 1
        case .downvote:
            questions[index].downvotes += 1
        case .none:
            break
        }
        
        questions[index].votes = questions[index].upvotes - questions[index].downvotes
    }
    
    func debugPrintQuestions() {
        let request = QuestionRequest(action: "debug_print")
        socketService.send(request) { _ in }
    }
    
    func filterQuestions(_ request: FilterQuestionsRequest) {
        socketService.send(request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder.shared.decode(ServerResponse.self, from: data)
                    if response.status == "success", let questions = response.data {
                        DispatchQueue.main.async {
                            self?.questions = questions
                        }
                    }
                } catch {
                    print("❌ Decoding error: \(error)")
                }
            case .failure(let error):
                print("❌ Network error: \(error)")
            }
        }
    }
    
    func sortQuestions(_ request: SortQuestionsRequest) {
        socketService.send(request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder.shared.decode(ServerResponse.self, from: data)
                    if response.status == "success", let questions = response.data {
                        DispatchQueue.main.async {
                            self?.questions = questions
                        }
                    }
                } catch {
                    print("❌ Decoding error: \(error)")
                }
            case .failure(let error):
                print("❌ Network error: \(error)")
            }
        }
    }
    
    func questionsWithTag(_ tag: String) -> [Question] {
        questions.filter { question in
            question.tags.contains(tag)
        }
    }
    
    // Similar implementations for other actions
} 

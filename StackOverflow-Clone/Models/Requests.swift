// Request types for the Stack Overflow clone
struct DeleteAnswerRequest: Codable {
    let action: String
    let answerId: String
    let questionId: String
    let authorId: String
    
    enum CodingKeys: String, CodingKey {
        case action
        case answerId = "answer_id"
        case questionId = "question_id"
        case authorId = "author_id"
    }
}

struct SortQuestionsRequest: Codable {
    let action: String
    let sortBy: String
    let searchText: String?
    
    enum CodingKeys: String, CodingKey {
        case action
        case sortBy = "sort_by"
        case searchText = "search_text"
    }
}

struct FilterQuestionsRequest: Codable {
    let action: String
    let searchText: String
    
    enum CodingKeys: String, CodingKey {
        case action
        case searchText = "search_text"
    }
}

struct DeleteQuestionRequest: Codable {
    let action: String
    let questionId: String
    let authorId: String
    
    enum CodingKeys: String, CodingKey {
        case action
        case questionId = "question_id"
        case authorId = "author_id"
    }
}

struct LoginRequest: Codable {
    let action: String
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case action
        case email
        case password
    }
}

struct SignUpRequest: Codable {
    let action: String
    let username: String
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case action
        case username
        case email
        case password
    }
} 
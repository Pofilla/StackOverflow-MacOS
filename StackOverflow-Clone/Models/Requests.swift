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
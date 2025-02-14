import Foundation

struct Answer: Codable, Identifiable {
    let id: String
    let questionId: String
    let authorId: String
    let body: String
    let createdDate: Date
    var votes: Int
    var isAccepted: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case questionId = "questionId"
        case authorId = "authorId"
        case body
        case createdDate = "created_date"
        case votes
        case isAccepted = "is_accepted"
    }
} 
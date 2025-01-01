import Foundation

struct Answer: Codable, Identifiable {
    let id: String
    let questionId: String
    let authorId: String
    let body: String
    let createdDate: Date
    var votes: Int
    var isAccepted: Bool
} 
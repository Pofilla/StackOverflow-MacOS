import Foundation

struct Question: Codable, Identifiable {
    let id: String
    let title: String
    let body: String
    let authorId: String
    let createdDate: Date
    var votes: Int
    var answers: [Answer]
    var tags: [String]
} 
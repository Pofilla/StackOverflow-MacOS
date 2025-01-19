import Foundation

struct ServerResponse: Codable {
    let status: String
    let message: String?
    let username: String? // For login responses
    let data: [Question]? // For question-related responses
    let lastModified: String? // For tracking updates
}

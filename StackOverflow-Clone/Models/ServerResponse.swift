import Foundation

struct ServerResponse: Codable {
    let status: String
    let message: String?
    let username: String? // Optional username field for login responses
    let data: [Question]? // Add this line if you expect a data array of questions
}

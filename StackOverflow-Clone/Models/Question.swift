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
    
    var upvotes: Int
    var downvotes: Int
    var totalVotes: Int { upvotes - downvotes }
    
    var userVotes: [String: VoteType] // [userId: voteType]
}

enum VoteType: Int, Codable {
    case downvote = -1
    case none = 0
    case upvote = 1
} 
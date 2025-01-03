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
    
    var userVotes: [String: VoteType]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case authorId = "author_id"
        case createdDate = "created_date"
        case votes
        case answers
        case tags
        case upvotes
        case downvotes
        case userVotes = "user_votes"
    }
    
    init(id: String, title: String, body: String, authorId: String, createdDate: Date, votes: Int, answers: [Answer], tags: [String], upvotes: Int, downvotes: Int, userVotes: [String: VoteType]) {
        self.id = id
        self.title = title
        self.body = body
        self.authorId = authorId
        self.createdDate = createdDate
        self.votes = votes
        self.answers = answers
        self.tags = tags
        self.upvotes = upvotes
        self.downvotes = downvotes
        self.userVotes = userVotes
    }
}

enum VoteType: Int, Codable {
    case downvote = -1
    case none = 0
    case upvote = 1
} 
import Foundation

struct UserSearchResult: Codable {
    let username: String
    let imageUrl: String
    let displayName: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case username
        case imageUrl = "avatar_url"
        case displayName = "display_name"
        case id
    }
}

struct SearchResponse: Codable {
    let ok: Bool
    let error: String?
    let users: [UserSearchResult]
}

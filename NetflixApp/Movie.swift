import Foundation

struct Movie: Codable, Hashable {
    let id: Int
    let overview: String
    let posterPath: String
    let title: String
}

import Foundation

nonisolated
struct Users: Codable, Sendable{
    let username: String
    let email: String
    let uid: String
}

import Foundation

struct Plant: Codable, Identifiable {
    let id: String
    let latitude: Double
    let longitude: Double
    let data: String
    let filePath: String
    let version: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case latitude, longitude, data, filePath = "file_path", version = "__v"
    }
}

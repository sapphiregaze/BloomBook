import Foundation
import UIKit

enum HTTPMethod: String {
    case GET
    case POST
}

func requestData(from urlString: String, method: HTTPMethod, completion: @escaping (Result<Data, Error>) -> Void) {
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
        return
    }

    var request = URLRequest(url: url)

    request.httpMethod = method.rawValue

    let session = URLSession.shared

    let task = session.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
            return
        }

        if (200...299).contains(httpResponse.statusCode) {
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NSError(domain: "No response data", code: 0, userInfo: nil)))
            }
        } else {
            completion(.failure(NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)))
        }
    }

    task.resume()
}

func uploadPhoto(from urlString: String, image: UIImage, latitude: Double, longitude: Double, completion: @escaping (Result<Data, Error>) -> Void) {
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    let boundary = "Boundary-\(UUID().uuidString)"
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

    var body = Data()

    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
    if let imageData = image.jpegData(compressionQuality: 0.8) {
        body.append(imageData)
    }
    body.append("\r\n".data(using: .utf8)!)

    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"latitude\"\r\n\r\n".data(using: .utf8)!)
    body.append("\(latitude)\r\n".data(using: .utf8)!)

    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"longitude\"\r\n\r\n".data(using: .utf8)!)
    body.append("\(longitude)\r\n".data(using: .utf8)!)

    body.append("--\(boundary)--\r\n".data(using: .utf8)!)

    let session = URLSession.shared

    let task = session.uploadTask(with: request, from: body) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
            return
        }

        if (200...299).contains(httpResponse.statusCode) {
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NSError(domain: "No response data", code: 0, userInfo: nil)))
            }
        } else {
            completion(.failure(NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)))
        }
    }

    task.resume()
}

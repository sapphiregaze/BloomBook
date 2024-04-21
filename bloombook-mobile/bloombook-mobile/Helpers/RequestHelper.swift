import Foundation

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

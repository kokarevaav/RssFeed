import Foundation

// MARK: - Network Layer
protocol NetworkServiceProtocol {
    func getNewsData(sourceURL: String, completion: @escaping (Data?, Error?) -> Void)
}

final class NetworkService: NetworkServiceProtocol {

    func getNewsData(sourceURL: String, completion: @escaping (Data?, Error?) -> Void) {

        guard let url = URL(string: sourceURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, _, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}


import Foundation

protocol NetworkDataFetcherProtocol {
    func fetchNewsData(sourceURL: String, completion: @escaping (Data?) -> ())
}

class NetworkDataFetcher: NetworkDataFetcherProtocol {
    
    private let networking: NetworkServiceProtocol
    
    init(networking: NetworkServiceProtocol = NetworkService()) {
        self.networking = networking
    }
    
    func fetchNewsData(sourceURL: String, completion: @escaping (Data?) -> ()) {
        networking.getNewsData(sourceURL: sourceURL) { (data, error) in
            if let error = error {
                print("Error recevied requesting data:  \(error.localizedDescription)")
                completion(nil)
            }
            completion(data)
        }
    }
}

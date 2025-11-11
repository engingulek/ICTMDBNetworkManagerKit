// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Alamofire

//MARK: NetworkManagerError
public enum NetworkManagerError: Error {
    case invalidURL       // Represents an invalid URL scenario
    case afError(AFError) // Wraps errors coming from Alamofire
}

//MARK: NetworkManagerProtocol
public protocol NetworkManagerProtocol {
   
    
    /// Executes a network request and returns the result asynchronously.
    /// - Parameters:
    ///   - request: The request conforming to NetworkRequest.
    ///   - completion: Closure returning a Result with the decoded response or an error. `Error` on failure.
    func execute<R: NetworkRequest>(
        _ request: R,
        completion: @escaping (Result<R.Response, Error>) -> Void
    )
}

//MARK: NetworkManager
@MainActor
public class NetworkManager: @preconcurrency NetworkManagerProtocol {
    public init() { }
    // Generic execute function that can handle any NetworkRequest type
    public func execute<R: NetworkRequest>(
        _ request: R,
        completion: @escaping (Result<R.Response, Error>) -> Void
    ) {
        
        guard let url = URL(string: Constant.baseURL) else {
            completion(.failure(NetworkManagerError.invalidURL))
            return
        }
        
        do {
            
            var urlRequest = try request.asURLRequest(baseURL: url)
            urlRequest.setValue("Bearer \(Constant.accessToken)", forHTTPHeaderField: "Authorization")
            // Send the request using Alamofire
            AF.request(urlRequest)
                .validate() // Ensures the response status code is acceptable (200-299)
                .responseDecodable(of: R.Response.self) { response in
                    switch response.result {
                    case .success(let value):
                        // Successfully decoded the response into the expected type
                        completion(.success(value))
                    case .failure(let error):
                        print("Error ->  \(error.localizedDescription)")
                        // Wrap Alamofire error into our custom NetworkManagerError
                        completion(.failure(NetworkManagerError.afError(error)))
                    }
                }
        } catch {
            print("Error -> \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
}

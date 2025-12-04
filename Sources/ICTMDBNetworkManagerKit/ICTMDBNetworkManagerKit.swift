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
public protocol NetworkManagerProtocol: Sendable {
   
    
    /// Executes a network request and returns the result asynchronously.
    /// - Parameters:
    ///   - request: The request conforming to NetworkRequest.
    ///   - completion: Closure returning a Result with the decoded response or an error. `Error` on failure.
    func execute<R: NetworkRequest>(
        _ request: R
    ) async throws -> R.Response
}

//MARK: NetworkManager
public class NetworkManager: @unchecked Sendable, NetworkManagerProtocol {
    public init() { }
    // Generic execute function that can handle any NetworkRequest type
    public func execute<R: NetworkRequest>(
        _ request: R
    ) async throws -> R.Response {
        
        guard let url = URL(string: Constant.baseURL) else {
            throw NetworkManagerError.invalidURL
        }
        
        do {
            var urlRequest = try request.asURLRequest(baseURL: url)
            urlRequest.setValue("Bearer \(Constant.accessToken)", forHTTPHeaderField: "Authorization")
            
            // Send the request using Alamofire
            let value = try await AF.request(urlRequest)
                .validate() // Ensures the response status code is acceptable (200-299)
                .serializingDecodable(R.Response.self)
                .value
            
            // Successfully decoded the response into the expected type
            return value
            
        } catch let error as AFError {
            print("Error ->  \(error.localizedDescription)")
            // Wrap Alamofire error into our custom NetworkManagerError
            throw NetworkManagerError.afError(error)
            
        } catch {
            print("Error -> \(error.localizedDescription)")
            throw error
        }
    }
}

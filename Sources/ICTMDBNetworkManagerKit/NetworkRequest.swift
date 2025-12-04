//
//  NetworkRequest.swift
//  YourApp
//
//  Created by Engin Gülek on 11.11.2025.
//

import Foundation

// MARK: - NetworkRequest Protocol
/// A protocol that defines the blueprint for building API requests.
/// Each request specifies its endpoint, HTTP method, headers, and parameters.
public protocol NetworkRequest: Sendable {
    
    /// The expected response type of the request.
    /// It must conform to both `Decodable` (for JSON parsing) and `Sendable` (for concurrency safety).
    associatedtype Response: Decodable, Sendable
    /// The API endpoint associated with this request, defined using `NetworkPath`.
    var path: NetworkPath { get }
    /// The HTTP method used for the request (e.g., GET, POST, PUT).
    var method: AlamofireMethod { get }
    /// Optional HTTP headers to be included in the request.
    /// Commonly used for authentication tokens or custom headers.
    var headers: [String: String]? { get }
    /// Optional parameters to send with the request.
    /// These can be encoded as query items or JSON depending on the HTTP method.
    var parameters: [String: Any]? { get }
}

// MARK: - NetworkRequest Default Implementation
/// Provides a default implementation to convert a `NetworkRequest`
/// into a standard `URLRequest` object that can be executed by URLSession.
public extension NetworkRequest {
    
    /// Builds and returns a configured `URLRequest` based on the current request properties.
    /// - Parameter baseURL: The base URL of the API
    /// - Throws: An error if the request cannot be properly encoded or constructed.
    /// - Returns: A fully configured `URLRequest` ready to be sent.
    func asURLRequest(baseURL: URL) throws -> URLRequest {
        
        // Construct the full URL by appending the endpoint path to the base URL.
        var url = baseURL.appendingPathComponent(path.path)
        
        // MARK: GET Parameters
        /// If the request method is GET, encode parameters as query items.
        if method == .GET, let parameters = parameters {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            url = components?.url ?? url
        }
        
        // MARK: Request Initialization
        ///Initialize the `URLRequest` with the URL and set its HTTP method.
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // MARK: Non-GET Request Body
        /// For non-GET methods (e.g., POST, PUT), encode parameters as JSON in the HTTP body.
        if method != .GET, let parameters = parameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        // MARK: Headers
        /// Attach additional headers (if provided) to the request.
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}



//
//  NetworkDefinitions.swift
//  YourApp
//
//  Created by Engin Gülek on 11.11.2025.
//

import Foundation

// MARK: - AlamofireMethod
/// Defines the available HTTP methods for network requests using Alamofire.
/// Currently supports `GET`, but can be extended for other methods like `POST`, `PUT`, or `DELETE`.
public enum AlamofireMethod: String {
    /// Represents an HTTP GET request, used to retrieve data from the server.
    case GET
}

// MARK: - NetworkPath
/// Represents API endpoints for the application’s network requests.
/// Each case corresponds to a specific route in the backend API.
public enum NetworkPath {
    /// Endpoint for fetching a list of popular TV shows
    case popular
    ///Endpoint for fetching TV shows that are airing today.
    case airingToday
    /// Endpoint for fetching detailed information about a specific TV show.
    /// - Parameter id: The unique identifier of the TV show.
    case detail(Int)
    /// Endpoint for fetching the cast of a specific TV show.
    /// - Parameter id: The unique identifier of the TV show.
    case casts(Int)
}

// MARK: - NetworkPath Extension
/// Provides the actual URL path string for each API endpoint defined in `NetworkPath`.
/// Converts enum cases into their corresponding API path components.
extension NetworkPath {
    var path: String {
        switch self {
        case .popular:
            return "popular"
        case .airingToday:
            return "airing_today"
        case .detail(let id):
            return "\(id)"
        case .casts(let id):
            return "\(id)/credits"
        }
    }
}

// MARK: - RequestLanguage
/// Defines the language preferences for API requests.
/// Used to localize API responses (e.g., Turkish or English).
public enum RequestLanguage {
    /// B2-C1 English: Turkish language option.
    case tr
    /// B2-C1 English: English language option.
    case en
}

// MARK: - RequestLanguage Extension
/// Converts `RequestLanguage` enum cases into ISO 639-1 language codes
/// recognized by the backend API.
extension RequestLanguage {
    var lang: String {
        switch self {
        case .tr:
            return "tr-TR"
        case .en:
            return "en-EN"
        }
    }
}

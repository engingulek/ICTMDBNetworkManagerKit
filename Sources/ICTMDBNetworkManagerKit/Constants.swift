//
//  Constant.swift
//  YourApp
//
//  Created by Engin Gülek on 11.11.2025.
//

import Foundation

// MARK: - Constant
/// A global configuration structure responsible for securely loading API credentials and constants
/// from the **Secret.plist** file located in the app bundle.
@MainActor
public struct Constant {
    
    // MARK: - Private Configuration Dictionary
    /// Loads the `Secret.plist` file and converts it into a `[String: Any]` dictionary.
    /// The file must exist in the module bundle, otherwise the app will terminate with a fatal error.
   private static let config: [String: Any] = {
        guard let url = Bundle.module.url(forResource: "Secret", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(
                from: data, options: [],
                format: nil) as? [String: Any] else {
            fatalError("❌ Secret.plist not found or corrupted.")
        }
        return plist
    }()
    
    // MARK: - Access Token
    /// The access token used for authenticating API requests.
    /// It is fetched from the `accessToken` key inside `Secret.plist`.
    ///
    /// - Important:
    /// The app will crash with a **fatalError** if the key does not exist.
    public static let accessToken: String = {
        guard let key = config["accessToken"] as? String else {
            fatalError("❌ accessToken key not found in Secret.plist.")
        }
        return key
    }()
    
    // MARK: - Base URL
    /// The base URL of the API.
    /// Retrieved from the `baseUrl` key in `Secret.plist`.
    public static let baseURL: String = {
        guard let url = config["baseUrl"] as? String else {
            fatalError("❌ baseUrl key not found in Secret.plist.")
        }
        return url
    }()
    
    // MARK: - Private Initializer
    /// Prevents external initialization of this struct,
    /// ensuring all properties are accessed statically.
    private init() {}
}


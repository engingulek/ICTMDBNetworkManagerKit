# ICTMDBNetworkManagerKit

NetworkManager is a Swift, Alamofire-based network layer solution. It provides a structured way to manage API requests, perform network calls, and decode responses in a type-safe manner.

### Features
- Type-safe generic network request handling (NetworkRequest protocol)
- HTTP requests via Alamofire (GET supported)
- Custom error handling with NetworkManagerError
- Dynamic URL and query parameter support
- Request header and Authorization token management
- Asynchronous callback using Result type

## Usage
1. Initialize NetworkManager
```swift
let networkManager = NetworkManager()
```

2. Create a NetworkRequest
 Define a struct for your API request:
```swift
struct PopularTVShowsRequest: NetworkRequest {
    typealias Response = PopularTVShowsResponse

    var path: NetworkPath { .popular }
    var method: AlamofireMethod { .GET }
    var headers: [String : String]? { nil }
    var parameters: [String : Any]? { ["language": RequestLanguage.en.lang] }
}

```

3. Execute the request
```swift
let request = PopularTVShowsRequest()

networkManager.execute(request) { result in
    switch result {
    case .success(let response):
        print("Success: \(response)")
    case .failure(let error):
        print("Error: \(error)")
    }
}

```
## NetworkPath

Defines API endpoints:

```swift
public enum NetworkPath {
    case popular
    case airingToday
    case detail(Int)
    case casts(Int)
}

```

- .popular → Popular TV shows
- .airingToday → TV shows airing today
- .detail(id) → Details of a specific TV show
- .casts(id) → Cast of a specific TV show


## RequestLanguage
Used to set language preference for API responses:

```swift
public enum RequestLanguage {
    case tr  // Turkish
    case en  // English
}

```

## NetworkRequest Protocol
The NetworkRequest protocol defines the blueprint for all network requests:

```swift
public protocol NetworkRequest {
    associatedtype Response: Decodable, Sendable
    var path: NetworkPath { get }
    var method: AlamofireMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}

```
- Response: Expected API response model (must conform to Decodable)
- path: API endpoint
- method: HTTP method (GET)
- headers: Additional headers (optional)
- parameters: Query or body parameters

## Installation


```swift

.package(url: "https://github.com/engingulek/ICTMDBNetworkManagerKit", from: "0.0.2")

```



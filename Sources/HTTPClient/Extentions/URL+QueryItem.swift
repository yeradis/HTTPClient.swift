import Foundation

public extension URL {
  func appendingQueryItem(_ name: String, value: Any?) -> URL {
    guard var urlComponents = URLComponents(string: absoluteString),
          let value = value else {
      return self
    }

    var queryItems = urlComponents.queryItems ?? []
    queryItems.append(URLQueryItem(name: name, value: "\(value)"))

    urlComponents.queryItems = queryItems
    return urlComponents.url ?? self
  }
}

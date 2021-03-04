import Foundation

public extension URLRequest {
  func asString() -> String {
    var values: [String: Any] = [:]
    values["headers"] = allHTTPHeaderFields
    values["url"] = url?.absoluteString
    return values.json!
  }
}

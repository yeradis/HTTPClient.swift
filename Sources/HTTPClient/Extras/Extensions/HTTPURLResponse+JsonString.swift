import Foundation

extension HTTPURLResponse {
  func asString() -> String {
    var values: [String: Any] = [:]
    values["statusCode"] = statusCode
    values["headers"] = allHeaderFields
    values["url"] = url?.absoluteString
    return values.json!
  }
}

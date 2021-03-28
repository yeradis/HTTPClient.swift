import Foundation

public extension HTTPURLResponse {
  func asString() -> String {
    var values: [String: Any] = [:]
    values["statusCode"] = statusCode
    values["headers"] = allHeaderFields
    values["mimeType"] = mimeType ?? "<unknown>"
    values["url"] = url?.absoluteString
    return values.jsonString!
  }
}

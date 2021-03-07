import Foundation

public extension Dictionary {
  var jsonString: String? {
    guard let jsonData = jsonData, let string = String(bytes: jsonData, encoding: String.Encoding.utf8) else {
      return nil
    }
    return string
  }
}

extension Dictionary {
  var jsonObject: Any? {
    guard let data = jsonData else {
      return nil
    }
    return try? JSONSerialization.jsonObject(with: data, options: [])
  }

  var jsonData: Data? {
    try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
  }
}

extension Dictionary where Key == String, Value == Any {

  func urlEncoded(_ encoding: HTTPParameterEncoding = .default) -> String {
    encoding.encode(self)
            .map {
              "\($0)=\($1)"
            }
            .joined(separator: "&")
  }

  func urlEncoded(_ encoding: HTTPParameterEncoding = .default) -> Data? {
    urlEncoded(encoding).data(using: .utf8)
  }
}
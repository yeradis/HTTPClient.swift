import Foundation

public extension Dictionary {
  var json: String? {
    guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted]),
          let string = String(bytes: jsonData, encoding: String.Encoding.utf8)
            else {
      return nil
    }
    return string
  }
}

extension Dictionary where Key == String, Value == Any {
  var json: Data? {
    try? JSONSerialization.data(withJSONObject: self, options: [])
  }
}

extension Dictionary where Key == String, Value == AnyObject {
  var json: Data? {
    try? JSONSerialization.data(withJSONObject: self, options: [])
  }
}
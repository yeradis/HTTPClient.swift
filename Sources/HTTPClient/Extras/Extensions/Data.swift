import Foundation

extension Data {

  var json: String? {
    guard let json = try? JSONSerialization.jsonObject(with: self, options: []),
          let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
          let string = String(data: data, encoding: String.Encoding.utf8)
            else {
      return nil
    }
    return string
  }

  static func json<T: Codable>(_ object: T) -> Data? {
    try? JSONEncoder().encode(object)
  }

  static func json<T: Codable>(type: T.Type, from data: Data) -> T? {
    try? JSONDecoder().decode(type, from: data)
  }
}

import Foundation

public extension Data {

  var jsonString: String? {
    guard let data = jsonData,
          let string = String(data: data, encoding: String.Encoding.utf8) else {
      return nil
    }
    return string
  }

  var jsonObject: Any? {
    guard let json = try? JSONSerialization.jsonObject(with: self, options: []) else {
      return nil
    }
    return json
  }

  var jsonData: Data? {
    guard let json = jsonObject,
          let data = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]) else {
      return nil
    }
    return data
  }

  static func jsonData<T: Codable>(_ object: T) -> Data? {
    try? JSONEncoder().encode(object)
  }

  static func jsonData<T: Codable>(type: T.Type, from data: Data) -> T? {
    try? JSONDecoder().decode(type, from: data)
  }

  var string: String? {
    jsonString ?? String(decoding: self, as: UTF8.self)
  }
}

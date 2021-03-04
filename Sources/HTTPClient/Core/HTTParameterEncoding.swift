import Foundation

public extension HTTPParameterEncoding {
  static let `default` = HTTPParameterEncoding()
}

public struct HTTPParameterEncoding {
  private let arrayEncoding: ArrayEncoding
  private let boolEncoding: BoolEncoding

  public init(arrayEncoding: ArrayEncoding = .brackets, boolEncoding: BoolEncoding = .literal) {
    self.arrayEncoding = arrayEncoding
    self.boolEncoding = boolEncoding
  }

  public func encode(_ parameters: [String: Any]) -> [(key: String, value: String)] {
    var components: [(key: String, value: String)] = []

    for key in parameters.keys.sorted(by: <) {
      let value = parameters[key]!
      components += queryComponents(fromKey: key, value: value)
    }
    return components
  }

  func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
    var components: [(String, String)] = []
    switch value {
    case let dictionary as [String: Any]:
      for (nestedKey, value) in dictionary {
        components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
      }
    case let array as [Any]:
      for value in array {
        components += queryComponents(fromKey: arrayEncoding.encode(key: key), value: value)
      }
    case let number as NSNumber:
      if number.isBool {
        components.append((escape(key), escape(boolEncoding.encode(value: number.boolValue))))
      } else {
        components.append((escape(key), escape("\(number)")))
      }
    case let bool as Bool:
      components.append((escape(key), escape(boolEncoding.encode(value: bool))))
    default:
      components.append((escape(key), escape("\(value)")))
    }
    return components
  }

  func escape(_ string: String) -> String {
    string.addingPercentEncoding(withAllowedCharacters: .paramAllowed) ?? string
  }
}

extension HTTPParameterEncoding {

  public enum ArrayEncoding {
    /// An empty set of square brackets is appended to the key for every value. This is the default behavior.
    case brackets
    /// No brackets are appended. The key is encoded as is.
    case noBrackets

    func encode(key: String) -> String {
      switch self {
      case .brackets:
        return "\(key)[]"
      case .noBrackets:
        return key
      }
    }
  }

/// Configures how `Bool` parameters are encoded.
  public enum BoolEncoding {
    /// Encode `true` as `1` and `false` as `0`. This is the default behavior.
    case numeric
    /// Encode `true` and `false` as string literals.
    case literal

    func encode(value: Bool) -> String {
      switch self {
      case .numeric:
        return value ? "1" : "0"
      case .literal:
        return value ? "true" : "false"
      }
    }
  }
}


extension NSNumber {
  fileprivate var isBool: Bool {
    // Use Obj-C type encoding to check whether the underlying type is a `Bool`, as it's guaranteed as part of
    // swift-corelibs-foundation, per [this discussion on the Swift forums](https://forums.swift.org/t/alamofire-on-linux-possible-but-not-release-ready/34553/22).
    String(cString: objCType) == "c"
  }
}
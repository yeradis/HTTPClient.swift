import Foundation

extension CharacterSet {
  
//https://github.com/AFNetworking/AFNetworking/blob/master/AFNetworking/AFURLRequestSerialization.m
  static let URLCharactersGeneralDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
  static let URLCharactersSubDelimitersToEncode = "!$&'()*+,;="
  
  static let paramAllowed = customCharacterSet()
  
  private static func customCharacterSet() -> CharacterSet {
    var custom = CharacterSet.urlFragmentAllowed.union(.urlQueryAllowed)
    custom.remove(charactersIn: "\(URLCharactersGeneralDelimitersToEncode)\(URLCharactersSubDelimitersToEncode)")
    return custom
  }
}

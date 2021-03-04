import Foundation

public extension String {
  var URLEncoded:String {
    addingPercentEncoding(withAllowedCharacters: CharacterSet.paramAllowed) ?? self
  }
}

import Foundation

public enum HTTPRequestMethod: String {
  case GET
  case POST
  case PATCH
  case PUT
  case DELETE

  var isGET: Bool {
    self == .GET
  }
}

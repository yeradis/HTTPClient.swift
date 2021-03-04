import Foundation

extension URL {

  func appendingPathComponentIfNotEmpty(_ pathComponent: String) -> URL {
    guard !pathComponent.isEmpty else {
      return self
    }
    return self.appendingPathComponent(pathComponent)
  }
}

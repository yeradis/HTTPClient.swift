import Foundation

extension NSError {
  static let networkError = NSError(domain: NSURLErrorDomain,code: NSURLErrorNetworkConnectionLost, userInfo: nil)
}
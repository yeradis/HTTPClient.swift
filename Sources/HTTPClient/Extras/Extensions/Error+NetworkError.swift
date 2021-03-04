import Foundation

public extension Error {
  var isNetworkError: Bool {
    (self as NSError).isNetworkError
  }
}

public extension NSError {
  var isNetworkError: Bool {
    switch code {
    case NSURLErrorTimedOut,
         NSURLErrorCannotFindHost,
         NSURLErrorCannotConnectToHost,
         NSURLErrorNetworkConnectionLost,
         NSURLErrorDNSLookupFailed,
         NSURLErrorNotConnectedToInternet,
         NSURLErrorInternationalRoamingOff,
         NSURLErrorCallIsActive,
         NSURLErrorDataNotAllowed:
      return true
    default:
      return false
    }
  }
}

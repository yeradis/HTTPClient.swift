import Foundation

extension Error {
  var isNetworkError: Bool {
    (self as NSError).isNetworkError
  }
}

extension NSError {
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

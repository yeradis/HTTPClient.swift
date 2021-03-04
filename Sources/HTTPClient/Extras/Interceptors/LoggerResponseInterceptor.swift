import Foundation

struct LoggerResponseInterceptor: HTTPInterceptor {
  typealias Input = URLResponse
  
  func intercept(_ object: LoggerResponseInterceptor.Input) -> LoggerResponseInterceptor.Input {
    guard let httpResponse = object as? HTTPURLResponse else {
      return object
    }
    Log.info("RESPONSE:\(httpResponse.asString())")
    return object
  }
  
  static func make() -> LoggerResponseInterceptor {
    LoggerResponseInterceptor()
  }
}

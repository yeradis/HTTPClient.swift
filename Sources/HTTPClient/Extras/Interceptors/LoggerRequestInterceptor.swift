import Foundation

struct LoggerRequestInterceptor: HTTPInterceptor {
  typealias Input = URLRequest
  
  func intercept(_ object: LoggerRequestInterceptor.Input) -> LoggerRequestInterceptor.Input {
    
    let bodyData = object.httpBody ?? Data()
    Log.info("REQUEST:\n\(object.asString())\nBODY:\n\(bodyData.json ?? "")")
    
    return object
  }
  
  static func make() -> LoggerRequestInterceptor {
    return LoggerRequestInterceptor()
  }
}

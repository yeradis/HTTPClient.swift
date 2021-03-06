import Foundation

public struct LoggerRequestInterceptor: HTTPInterceptor {
  public typealias Input = URLRequest
  
  public func intercept(_ object: LoggerRequestInterceptor.Input) -> LoggerRequestInterceptor.Input {
    
    let bodyData = object.httpBody ?? Data()
    Log.info("REQUEST:\n\(object.asString())\nBODY:\n\(bodyData.string ?? "")")
    
    return object
  }
  
  static func make() -> LoggerRequestInterceptor {
    return LoggerRequestInterceptor()
  }
}

import Foundation

public class HTTPInterceptorChain<Input> {

  private var interceptors: [HTTPAnyInterceptor<Input>]

  init(interceptors: [HTTPAnyInterceptor<Input>] = []) {
    self.interceptors = interceptors
  }

  public func add(interceptor: HTTPAnyInterceptor<Input>) -> HTTPInterceptorChain {
    interceptors.append(interceptor)

    return self
  }

  public func proceed(_ object: Input) -> Input {
    let objectResult = interceptors.reduce(object) { (result, object) -> Input in
      return object.intercept(result)
    }

    return objectResult
  }

  public var count: Int {
    return interceptors.count
  }
}

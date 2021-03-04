import Foundation

public struct HTTPAnyInterceptor<Input>: HTTPInterceptor {
  
  private let _intercept: (Input) -> Input

  public init<I: HTTPInterceptor>(base: I) where I.Input == Input {
    _intercept = base.intercept
  }

  public func intercept(_ object: Input) -> Input {
    _intercept(object)
  }
}

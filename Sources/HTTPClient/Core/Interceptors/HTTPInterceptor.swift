import Foundation

public protocol HTTPInterceptor {
  associatedtype Input

  func intercept(_ object: Input) -> Input
}

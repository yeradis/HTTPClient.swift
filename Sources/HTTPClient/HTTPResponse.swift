import Foundation

public typealias HTTPStatusCode = Int

public struct HTTPResponse {
  public let status: HTTPStatusCode
  public let request: URLRequest?
  public let body: Data?
  public let response: URLResponse?
  public let value: Any?
}
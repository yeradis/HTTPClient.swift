import Foundation

public typealias HTTPStatusCode = Int

public struct HTTPResponse {
  public let status: HTTPStatusCode
  public let request: URLRequest?
  public let body: Data?
  public let response: URLResponse?
  public let value: Any?

  public init(status: HTTPStatusCode, request: URLRequest? = nil, body: Data? = nil, response: URLResponse? = nil, value: Any? = nil) {
    self.status = status
    self.request = request
    self.body = body
    self.response = response
    self.value = value
  }
}
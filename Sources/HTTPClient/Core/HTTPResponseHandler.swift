import Foundation

public protocol HTTPResponseHandler {
  func handle(_ data: Data?, request: URLRequest?, response: URLResponse?, _ error: Error?, completion: @escaping (Result<HTTPResponse, HTTPClientError>) -> ())
}

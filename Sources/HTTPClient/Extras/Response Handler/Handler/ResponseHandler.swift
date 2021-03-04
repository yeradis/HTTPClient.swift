import Foundation

public struct ResponseHandler: HTTPResponseHandler {

  public func handle(_ data: Data?, request: URLRequest?, response: URLResponse?, _ error: Error?, completion: @escaping (Result<HTTPResponse, HTTPClientError>) -> ()) {
    if let error = error {
      completion(Result(error: .httpClientError(error: error)))
      return
    }

    guard let httpResponse = response as? HTTPURLResponse else {
        completion(Result(error: .networkError))
        return
    }

    let bodyData = data ?? Data()

    if (200 ..< 300 ~= httpResponse.statusCode) {
      let response = HTTPResponse(status: httpResponse.statusCode, request: request, body: bodyData, response: response, value: nil)
      completion(Result(value: response))
    } else {
      completion(Result(error: .unknown))
    }
  }
}

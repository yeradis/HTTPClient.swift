import Foundation

struct ResponseHandlerLogger: HTTPResponseHandler {
  var responseHandler:HTTPResponseHandler?

  init(_ responseHandler:HTTPResponseHandler? = nil) {
    self.responseHandler = responseHandler
  }

  func handle(_ data: Data?, request: URLRequest?, response: URLResponse?, _ error: Error?, completion: @escaping (Result<HTTPResponse, HTTPClientError>) -> ()) {
    if let httpResponse = response as? HTTPURLResponse {
      let bodyData = data ?? Data()
      Log.info("RESPONSE:\n\(httpResponse.statusCode) \(httpResponse.asString())\nBODY:\n\(bodyData.json ?? "")")
    }

    if let error = error {
      Log.error("\(error.localizedDescription)\n\(error)")
    }

    responseHandler?.handle(data, request: request, response: response, error, completion: completion)
  }
}

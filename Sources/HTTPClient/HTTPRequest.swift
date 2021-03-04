import Foundation

public typealias HTTPHeaders = [String: String]
public typealias HTTPParameters = [String: Any]

public protocol HTTPRequest {
  var method: HTTPRequestMethod { get }
  var path: String { get }
  var headers: HTTPHeaders? { get }
  var parameters: HTTPParameters? { get }
  var body: Data? { get }
  var contentType: HTTPContentType? { get }
  var responseHandler: HTTPResponseHandler? { get }

  func build(using baseURL: URL, parameterEncoding: HTTPParameterEncoding) -> URLRequest
}

extension HTTPRequest {

  var method: HTTPRequestMethod {
    .GET
  }

  public var headers: HTTPHeaders? {
    nil
  }

  var parameters: HTTPParameters? {
    nil
  }

  var body: Data? {
    nil
  }

  var contentType: HTTPContentType? {
    .applicationJSON
  }

  var responseHandler: HTTPResponseHandler? {
    nil
  }
}

extension HTTPRequest {

  func build(using baseURL: URL, parameterEncoding: HTTPParameterEncoding = .default) -> URLRequest {
    let url = baseURL.appendingPathComponentIfNotEmpty(path)

    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!

    var endpoint = components.url!

    if let parameters = parameters, !parameters.isEmpty && !useParametersAsBody {
      endpoint = parameterEncoding
              .encode(parameters)
              .reduce(endpoint) {
                $0.appendingQueryItem($1.key, value: $1.value)
              }
    }

    var request = URLRequest(url: endpoint)
    request.httpMethod = method.rawValue

    headers?.forEach { key, value in
      request.setValue(value, forHTTPHeaderField: key)
    }

    if let contentType = contentType {
      request.setValue(contentType.value, forHTTPHeaderField: "Content-Type")
    }

    if let body = body {
      request.httpBody = body
    }

    if let parameters = parameters, !parameters.isEmpty && useParametersAsBody {
      request.httpBody = parameterEncoding
              .encode(parameters)
              .map {
                "\($0)=\($1)"
              }
              .joined(separator: "&")
              .data(using: .utf8)
    }

    return request
  }
}

extension HTTPRequest {
  var useParametersAsBody: Bool {
    contentType == .applicationFORM && !method.isGET && body == nil
  }
}

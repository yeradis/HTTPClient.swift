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

public extension HTTPRequest {

  var method: HTTPRequestMethod {
    .GET
  }

  var headers: HTTPHeaders? {
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

public extension HTTPRequest {

  func build(using baseURL: URL, parameterEncoding: HTTPParameterEncoding = .default) -> URLRequest {
    let url = baseURL.appendingPathComponentIfNotEmpty(path)

    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!

    var endpoint = components.url!

    if let parameters = parameters, !parameters.isEmpty && !useParametersUrlEncodedAsBody {
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

    if useParametersUrlEncodedAsBody {
      request.httpBody = parameters?.urlEncoded(parameterEncoding)
    } else if useParametersJSONEncodedAsBody {
      request.httpBody = parameters?.jsonData
    }

    if let body = request.httpBody {
      request.setValue("\(body.count)", forHTTPHeaderField:"Content-Length")
    }

    return request
  }
}

extension HTTPRequest {
  var useParametersUrlEncodedAsBody: Bool {
    contentType == .applicationFORM && !method.isGET && body == nil
  }

  var useParametersJSONEncodedAsBody: Bool {
    contentType == .applicationJSON && !method.isGET && body == nil
  }
}

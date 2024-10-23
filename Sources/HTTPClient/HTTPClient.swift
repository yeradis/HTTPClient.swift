import Foundation

public final class HTTPClient {

  private let baseURL: URL
  private let session: URLSession

  private var requestInterceptor: HTTPInterceptorChain<URLRequest>
  private var responseInterceptor: HTTPInterceptorChain<URLResponse>

  private let responseHandler: HTTPResponseHandler

  public convenience init(baseURL: URL,
       configuration: URLSessionConfiguration = URLSessionConfiguration.default,
       responseHandler: HTTPResponseHandler,
       requestInterceptor: HTTPInterceptorChain<URLRequest>,
       responseInterceptor: HTTPInterceptorChain<URLResponse>) {

    self.init(
			baseURL: baseURL,
			delegate: nil,
			responseHandler: responseHandler,
			requestInterceptor: requestInterceptor,
			responseInterceptor: responseInterceptor
		)
  }
	
	public init(baseURL: URL,
	            configuration: URLSessionConfiguration = URLSessionConfiguration.default,
	            delegate: URLSessionDelegate?,
	            responseHandler: HTTPResponseHandler,
	            requestInterceptor: HTTPInterceptorChain<URLRequest>,
	            responseInterceptor: HTTPInterceptorChain<URLResponse>)
	{
		self.baseURL = baseURL
		session = URLSession(
			configuration: configuration,
			delegate: delegate,
			delegateQueue: nil
		)

		self.responseHandler = responseHandler
		self.requestInterceptor = requestInterceptor
		self.responseInterceptor = responseInterceptor
	}
}

extension HTTPClient {
  public func perform<T: Decodable>(_ request: HTTPRequest, completion: @escaping (Result<T, HTTPClientError>) -> Void) {
    perform(request) { (result: Result<HTTPResponse, HTTPClientError>) in
      if let error = result.error {
        completion(Result(error: error))
        return
      }

      guard let value = result.value?.body else {
        completion(Result(error: .parsingError))
        return
      }

      do {
        let object: T = try JSONDecoder().decode(T.self, from: value)
        completion(Result(value: object))
      } catch {
        completion(Result(error: .parsingError))
      }
    }
  }

  public func perform(_ request: HTTPRequest, completion: @escaping (Result<HTTPResponse, HTTPClientError>) -> Void) {
    let requestIntercepted = requestInterceptor.proceed(request.build(using: baseURL))
    let task = session.dataTask(with: requestIntercepted) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
      var responseIntercepted = response
      if let response = response {
        responseIntercepted = self?.responseInterceptor.proceed(response)
      }

      (request.responseHandler ?? self?.responseHandler)?.handle(data, request: requestIntercepted, response: responseIntercepted, error, completion: completion)
    }
    task.resume()
  }
}

extension HTTPClient {

  public func add(request interceptor: HTTPAnyInterceptor<URLRequest>) -> HTTPInterceptorChain<URLRequest> {
    requestInterceptor.add(interceptor: interceptor)
  }

  public func add(response interceptor: HTTPAnyInterceptor<URLResponse>) -> HTTPInterceptorChain<URLResponse> {
    responseInterceptor.add(interceptor: interceptor)
  }
}

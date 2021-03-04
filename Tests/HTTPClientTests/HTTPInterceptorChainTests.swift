import XCTest
@testable import HTTPClient

class HTTPInterceptorChainTests: XCTestCase {
  var sut: HTTPInterceptorChain<URLRequest>!

  func test_AddInterceptors_And_MatchCount() {
    sut = sut
            .add(interceptor: HTTPAnyInterceptor(base: TestHeaderAppenderInterceptor(headerKey: "key1", headerValue: "value1")))
            .add(interceptor: HTTPAnyInterceptor(base: TestHeaderAppenderInterceptor(headerKey: "key2", headerValue: "value2")))
    XCTAssertEqual(sut.count, 2)
  }

  func test_Interceptors_AddHeaders_And_MatchValues() {
    sut = sut
            .add(interceptor: HTTPAnyInterceptor(base: TestHeaderAppenderInterceptor(headerKey: "key1", headerValue: "value1")))
            .add(interceptor: HTTPAnyInterceptor(base: TestHeaderAppenderInterceptor(headerKey: "key2", headerValue: "value2")))

    let request = URLRequest(url: URL(string: "https://test.com/")!)
    let requestIntercepted = sut.proceed(request)

    XCTAssertEqual(requestIntercepted.value(forHTTPHeaderField: "key1")!, "value1")
    XCTAssertEqual(requestIntercepted.value(forHTTPHeaderField: "key2")!, "value2")
    XCTAssertEqual(requestIntercepted.allHTTPHeaderFields!.count, 2)
  }
}

extension HTTPInterceptorChainTests {
  override func setUp() {
    super.setUp()

    createSut()
  }

  func createSut() {
    sut = HTTPInterceptorChain<URLRequest>()
  }

  override func tearDown() {
    destroySut()

    super.tearDown()
  }

  func destroySut() {
    sut = nil
  }
}

extension HTTPInterceptorChainTests {

  struct TestHeaderAppenderInterceptor: HTTPInterceptor {
    let headerKey: String
    let headerValue: String

    typealias Input = URLRequest

    func intercept(_ object: TestHeaderAppenderInterceptor.Input) -> TestHeaderAppenderInterceptor.Input {
      var request = object
      request.addValue(headerValue, forHTTPHeaderField: headerKey)
      return request
    }
  }
}

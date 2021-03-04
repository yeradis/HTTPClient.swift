import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import HTTPClient

final class HTTPClientTests: XCTestCase {

  var sut: HTTPClient?

  override func setUp() {
    super.setUp()
    createSut()
  }

  override func tearDown() {
    HTTPStubs.removeAllStubs()
    super.tearDown()
  }

  func testReturnJSON_And_MatchResponse() {
    httpStub(contentOfFile: "test")

    expectFulfillment(before: 1) { expectation in

      sut?.perform(StubRequest()) { (resultData: Result<TestModel, HTTPClientError>) in
        XCTAssertEqual(resultData.value!.foo, "hello, world!")
        expectation.fulfill()
      }

    }
  }

  func testReturnsStatus200() {
    httpStub("")

    expectFulfillment(before: 1) { expectation in

      sut?.perform(StubRequest()) { (resultData: Result<HTTPResponse, HTTPClientError>) in
        XCTAssertEqual(resultData.value!.status, 200)
        expectation.fulfill()
      }

    }
  }

  func testReturnsNetworkError() {
    httpStub(NSError.networkError)

    expectFulfillment(before: 1) { expectation in

      sut?.perform(StubRequest()) { (resultData: Result<HTTPStatusCode, HTTPClientError>) in
        let error = HTTPClientError.httpClientError(error: NSError.networkError)
        XCTAssertEqual(resultData.error!, error)

        expectation.fulfill()
      }

    }
  }

  func testInterceptorAppendHeaders() {
    let expectation = XCTestExpectation()

    let appender = HTTPInterceptorChainTests.TestHeaderAppenderInterceptor(headerKey: "headerAppended", headerValue: "valueAppended")
    let headerAppenderInterceptor = HTTPAnyInterceptor(base: appender)
    _ = sut?.add(request: headerAppenderInterceptor)

    stub(condition: isHost("test.com")) { request in
      XCTAssertNotNil(request)
      XCTAssertNotNil(request.value(forHTTPHeaderField: appender.headerKey))

      XCTAssertEqual(request.value(forHTTPHeaderField: appender.headerKey)!, appender.headerValue)
      expectation.fulfill()

      return HTTPStubsResponse(data: Data(), statusCode: 200, headers: nil)
    }

    sut?.perform(StubRequest()) { _ in }

    wait(for: [expectation], timeout: 2.0)
  }
}

extension HTTPClientTests {
  private func createSut() {
    let configuration = URLSessionConfiguration.default

    sut = HTTPClient(
            baseURL: URL(string: "http://test.com")!,
            configuration: configuration,
            responseHandler: ResponseHandlerLogger(ResponseHandler()),
            requestInterceptor: getRequestInterceptor(),
            responseInterceptor: getResponseInterceptor()
    )
  }

  private func getRequestInterceptor() -> HTTPInterceptorChain<URLRequest> {
    HTTPInterceptorChain<URLRequest>()
            .add(interceptor: HTTPAnyInterceptor(base: LoggerRequestInterceptor.make()))
  }

  private func getResponseInterceptor() -> HTTPInterceptorChain<URLResponse> {
    HTTPInterceptorChain<URLResponse>()
            .add(interceptor: HTTPAnyInterceptor(base: LoggerResponseInterceptor.make()))
  }
}

extension HTTPClientTests {

  static var allTests = [
    ("testReturnJSON_And_MatchResponse", testReturnJSON_And_MatchResponse),
    ("testReturnsStatus200", testReturnsStatus200),
    ("testReturnsNetworkError", testReturnsNetworkError)
  ]
}

extension HTTPClientTests {
  struct TestModel: Decodable {
    let foo: String
  }

  struct StubRequest: HTTPRequest {
    let path: String = "object"
    let parameters: HTTPParameters? = ["testing": "true"]
    var contentType: HTTPContentType? = .applicationJSON
  }
}
import XCTest
@testable import HTTPClient

class HTTPRequestTests: XCTestCase {

  func testRequestBuild() {
    let request = StubRequest.example.build(using: URL(string: "https://test.com/api")!)

    XCTAssertEqual(request.url?.path, "/api/v1/test")
    XCTAssertEqual(request.httpMethod, "POST")

    XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")

    let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)
    XCTAssertEqual(components?.queryItems?.count, 7)
    XCTAssertEqual(components?.queryItems?.filter { $0.name == "param 1".URLEncoded }.first?.value, "one")
    XCTAssertEqual(components?.queryItems?.filter { $0.name == "param 2".URLEncoded }.first?.value, "two")
    XCTAssertEqual(components?.queryItems?.filter { $0.name == "param 3".URLEncoded }.first?.value, "true")
    XCTAssertEqual(components?.queryItems?.filter { $0.name == "param 4".URLEncoded }.first?.value, "1")

    XCTAssertEqual(components?.queryItems?.filter { $0.name == "param 5[]".URLEncoded }.count, 3)
  }
}

extension HTTPRequestTests {

  enum StubRequest: HTTPRequest {

    case example

    var method: HTTPRequestMethod {
      .POST
    }

    var path: String {
      "v1/test"
    }

    var parameters: HTTPParameters? {
      [
        "param 1": "one",
        "param 2": "two",
        "param 3": true,
        "param 4": 1,
        "param 5": [1,true,"tres"]
      ]
    }
    var contentType: HTTPContentType? {
      .applicationJSON
    }
  }
}
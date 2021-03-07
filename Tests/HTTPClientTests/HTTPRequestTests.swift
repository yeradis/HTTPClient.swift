import XCTest
@testable import HTTPClient

class HTTPRequestTests: XCTestCase {

  func test_ReturnParametersAsJSON_Having_MethodPOST_ContentTypeJSON_And_NilBody() {
    let httpRequest = StubRequest(.POST, .applicationJSON)
    let request = httpRequest.build(using: URL(string: "https://test.com/api")!)

    XCTAssertEqual(request.url?.path, "/api/v1/test")
    XCTAssertEqual(request.httpMethod, HTTPRequestMethod.POST.rawValue)
    XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), HTTPContentType.applicationJSON.value)

    XCTAssertNotNil(request.httpBody)

    let dict = request.httpBody?.jsonObject as! [String: Any]
    XCTAssertNotNil(dict["param 1"])
    XCTAssertNotNil(dict["param 2"])
    XCTAssertNotNil(dict["param 3"])
    XCTAssertNotNil(dict["param 4"])
    XCTAssertTrue((dict["param 5"] as! [Any]).count > 0)
  }

  func test_ReturnParametersURLEncodedInBody_Having_MethodPOST_ContentTypeFORM_And_NilBody() {
    let httpRequest = StubRequest(.POST, .applicationFORM)
    let request = httpRequest.build(using: URL(string: "https://test.com/api")!)

    XCTAssertEqual(request.url?.path, "/api/v1/test")
    XCTAssertEqual(request.httpMethod, HTTPRequestMethod.POST.rawValue)
    XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), HTTPContentType.applicationFORM.value)

    let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)
    XCTAssertNil(components?.queryItems)

    XCTAssertNotNil(request.httpBody)
    XCTAssertNotNil(request.httpBody?.string)
    XCTAssertEqual(request.httpBody?.string, httpRequest.parameters?.urlEncoded())
  }
}

extension HTTPRequestTests {

  struct StubRequest: HTTPRequest {
    private let httpMethod: HTTPRequestMethod
    private let httpContentType: HTTPContentType

    init(_ httpMethod: HTTPRequestMethod, _ httpContentType: HTTPContentType) {
      self.httpMethod = httpMethod
      self.httpContentType = httpContentType
    }

    var method: HTTPRequestMethod {
      httpMethod
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
      httpContentType
    }
  }
}
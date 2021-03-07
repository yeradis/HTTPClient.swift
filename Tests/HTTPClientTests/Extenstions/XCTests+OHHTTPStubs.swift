import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import HTTPClient

@nonobjc extension XCTestCase {

  func httpStub(_ content: String, statusCode: Int32 = 200, hostUrl: String = "test.com", headers: [AnyHashable: Any]? = nil) {
    httpStub(content.data(using: .utf8)!, statusCode: statusCode, hostUrl: hostUrl, headers: headers)
  }

  func httpStub(_ content: Data, statusCode: Int32 = 200, hostUrl: String = "test.com", headers: [AnyHashable: Any]? = nil) {
    stub(condition: isHost(hostUrl)) { _ in
      HTTPStubsResponse(data: content, statusCode: statusCode, headers: headers)
    }
  }

  func httpStub(_ content: [AnyHashable: Any], statusCode: Int32 = 200, hostUrl: String = "test.com", headers: [AnyHashable: Any]? = nil) {
    httpStub(content.jsonString!, statusCode: statusCode, hostUrl: hostUrl, headers: headers)
  }

  func httpStub(_ error: Error, statusCode: Int32 = 500, hostUrl: String = "test.com", headers: [AnyHashable: Any]? = nil) {
    stub(condition: isHost(hostUrl)) { _ in
      HTTPStubsResponse(error: error)
    }
  }

  func httpStub(contentOfFile resource: String, ofType ext: String = "json", statusCode: Int32 = 200, hostUrl: String = "test.com", headers: [AnyHashable: Any] = ["Content-Type": "application/json"]) {
    stub(condition: isHost(hostUrl)) { _ in
      guard let path = Bundle.module.path(forResource: resource, ofType: ext) else {
        fatalError("resource \(resource) is missing")
      }
      return fixture(filePath: path, status: statusCode, headers: headers)
    }
  }
}
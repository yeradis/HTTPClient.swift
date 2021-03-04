import XCTest
@testable import HTTPClient

class HTTPParameterEncodingTest: XCTestCase {
  var sut = HTTPParameterEncoding()
  private var parameters: HTTPParameters? {
    [
      "param 1": "one",
      "param 2": "two",
      "param 3": true,
      "param 4": 1,
      "param 5": [1,true,"tres"]
    ]
  }

  func testEncodeParameters_AndMatch() {
    let encoded = sut.encode(parameters!)
    XCTAssertTrue(encoded.count > 0)
    XCTAssertEqual(encoded.filter { $0.key == "param 1".URLEncoded }.first?.value, "one")
    XCTAssertEqual(encoded.filter { $0.key == "param 2".URLEncoded }.first?.value, "two")
    XCTAssertEqual(encoded.filter { $0.key == "param 3".URLEncoded }.first?.value, "true")
    XCTAssertEqual(encoded.filter { $0.key == "param 4".URLEncoded }.first?.value, "1")

    XCTAssertEqual(encoded.filter { $0.key == "param 5[]".URLEncoded }.count, 3)
    XCTAssertEqual(encoded.filter { $0.key == "param 5[]".URLEncoded }[0].value, "1")
    XCTAssertEqual(encoded.filter { $0.key == "param 5[]".URLEncoded }[1].value, "true")
    XCTAssertEqual(encoded.filter { $0.key == "param 5[]".URLEncoded }[2].value, "tres")
    Log.info(encoded)
  }
}
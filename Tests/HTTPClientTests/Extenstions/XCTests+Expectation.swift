import XCTest

extension XCTestCase {
  func expectFulfillment(before seconds: TimeInterval, description: String = "", in file: StaticString = #file,
                         line: UInt = #line, _ completion: (XCTestExpectation) -> Void) {
    let expectation = self.expectation(description: description)
    completion(expectation)
    self.waitForExpectations(timeout: seconds) { error in
      if let error = error {
        let message = description.isEmpty ? error.localizedDescription : " \(description)"
        XCTFail("Timed out waiting for expectations fulfillment.\(message)", file: file, line: line)
      }
    }
  }
}
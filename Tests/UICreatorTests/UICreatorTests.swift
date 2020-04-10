import XCTest
@testable import UICreator

final class UICreatorTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(UICreator().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

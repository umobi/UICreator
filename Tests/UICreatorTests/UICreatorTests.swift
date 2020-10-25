import XCTest
@testable import UICreator

final class UICreatorTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//        XCTAssertEqual(UICreator().text, "Hello, World!")
        print(UICNavigation {
            Slider()
        }.releaseUIView())
    }

    static var allTests = [
        ("testExample", testExample)
    ]
}

import UIKit
struct Slider: UICViewRepresentable {
    typealias View = UISlider

    func makeUIView() -> UISlider {
        UISlider()
    }

    func updateUIView(_ uiView: UISlider) {}
}

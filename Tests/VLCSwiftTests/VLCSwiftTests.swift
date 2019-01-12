import XCTest
@testable import VLCSwift

final class VLCSwiftTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(VLCSwift().text, "Hello, World!")
    }

    func testLibVLCInit() {
        XCTAssertNotNil(VLCInstance())
        XCTAssertNil(VLCInstance(arguments: ["--something-unknown"]))
    }

    func testLibVLCVersion() {
        let ver3_0_0_0 = VLCVersion.init(major: 3, minor: 0, revision: 0, extra: 0)
        let ver3_0_0_1 = VLCVersion.init(major: 3, minor: 0, revision: 0, extra: 1)
        let ver4_0_0_0 = VLCVersion.init(major: 4, minor: 0, revision: 0, extra: 0)

        // A version should be equal to itself
        XCTAssertEqual(ver3_0_0_0, ver3_0_0_0)

        // A version should be lower than a bigger one
        XCTAssertLessThan(ver3_0_0_0, ver3_0_0_1)

        // The current version should match 4.0.0.0 (for now)
        XCTAssertEqual(ver4_0_0_0, VLCVersion.current)
    }

    func testLibVLCProps() {
        XCTAssertEqual(VLCInstance.version, "4.0.0-dev Otto Chriek")
    }

    static var allTests = [
        ("testExample", testExample),
        ("testLibVLCInit", testLibVLCInit),
        ("testLibVLCVersion", testLibVLCVersion),
    ]
}

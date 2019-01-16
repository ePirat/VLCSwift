import XCTest
@testable import VLCSwift

final class VLCSwiftTests: XCTestCase {
    /**
     Creates a URL for a temporary file on disk. Registers a teardown block to
     delete a file at that URL (if one exists) during test teardown.
     */
    func temporaryFileURL() -> URL {

        // Create a URL for an unique file in the system's temporary directory.
        let directory = NSTemporaryDirectory()
        let filename = UUID().uuidString
        let fileURL = URL(fileURLWithPath: directory).appendingPathComponent(filename)

        // Add a teardown block to delete any file at `fileURL`.
        addTeardownBlock {
            do {
                let fileManager = FileManager.default
                // Check that the file exists before trying to delete it.
                if fileManager.fileExists(atPath: fileURL.path) {
                    // Perform the deletion.
                    try fileManager.removeItem(at: fileURL)
                    // Verify that the file no longer exists after the deletion.
                    XCTAssertFalse(fileManager.fileExists(atPath: fileURL.path))
                }
            } catch {
                // Treat any errors during file deletion as a test failure.
                XCTFail("Error while deleting temporary file: \(error)")
            }
        }

        // Return the temporary file URL for use in a test method.
        return fileURL

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

    func testLibVLCLogFile() {
        let fileURL = temporaryFileURL()

        let libVLC = VLCInstance()!
        XCTAssertTrue(libVLC.setLog(fileURL: fileURL))
    }

    static var allTests = [
        ("testLibVLCInit", testLibVLCInit),
        ("testLibVLCVersion", testLibVLCVersion),
        ("testLibVLCLogFile", testLibVLCLogFile),
    ]
}

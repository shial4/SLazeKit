import Foundation
import XCTest
@testable import SLazeKit

class StringPathTests: XCTestCase {
    static var allTests = [
            ("testPath", testPath),
            ("testPathTwoElements", testPathTwoElements),
            ("testPathThreeElements", testPathThreeElements),
            ("testPathFourElements", testPathFourElements),
        ]
    
    func testPath() {
        let path: String = "www.yourdomain.com/:object/59BA56C1-4AC4-4FE1-BA7D-366806F50A06"
        XCTAssertTrue(path.patternToPath(with: ["object":"MyModel"]) == "www.yourdomain.com/MyModel/59BA56C1-4AC4-4FE1-BA7D-366806F50A06")
    }
    
    func testPathTwoElements() {
        let path: String = "www.yourdomain.com/:object/59BA56C1-4AC4-4FE1-BA7D-366806F50A06/:date"
        XCTAssertTrue(path.patternToPath(with: [
            "object":"MyModel",
            "date":"2018-02-01 10:10:04"
            ]) == "www.yourdomain.com/MyModel/59BA56C1-4AC4-4FE1-BA7D-366806F50A06/2018-02-01 10:10:04")
    }
    
    func testPathThreeElements() {
        let path: String = "www.yourdomain.com/type/:object/:type/object/59BA56C1-4AC4-4FE1-BA7D-366806F50A06/:date"
        XCTAssertTrue(path.patternToPath(with: [
            "object":"MyModel",
            "date":"2018-02-01 10:10:04",
            "type":"example"
            ]) == "www.yourdomain.com/type/MyModel/example/object/59BA56C1-4AC4-4FE1-BA7D-366806F50A06/2018-02-01 10:10:04")
    }
    
    func testPathFourElements() {
        let path: String = "www.yourdomain.com/type/:object/:type/object/59BA56C1-4AC4-4FE1-BA7D-366806F50A06/id/id:/:id/:date"
        XCTAssertTrue(path.patternToPath(with: [
            "object":"MyModel",
            "date":"2018-02-01 10:10:04",
            "type":"example",
            "id":"12",
            ]) == "www.yourdomain.com/type/MyModel/example/object/59BA56C1-4AC4-4FE1-BA7D-366806F50A06/id/id:/12/2018-02-01 10:10:04")
    }
}

import Foundation
import XCTest
@testable import SLazeKit

extension Int: StringInitializable {
    public init?(rawValue: String) {
        guard let value = Int(rawValue) else { return nil }
        self = value
    }
}

class StringInitializableTests: XCTestCase {
    static var allTests = [
        ("testStringInitializable", testStringInitializable),
        ]
    
    func testStringPathPattern() {
        struct PathPattern {
            static var pathOne: String { return "/api/model/:objectId/sub" }
            static var pathTwo: String { return "/api/model" }
            static var pathThree: String { return "/api/model/:objectId/sub" }
            static var pathFour: String { return "/api/model/:objectId/sub/rel/:sub" }
            static var pathFive: String { return "/api/sub/:sub/users/:userId/el/rel" }
        }
        XCTAssert(PathPattern.pathOne.patternToPath(with: ["objectId":"1"]) == "/api/model/1/sub")
        XCTAssert(PathPattern.pathTwo.patternToPath() == "/api/model")
        XCTAssert(PathPattern.pathThree.patternToPath(with: ["objectId":"3"]) == "/api/model/3/sub")
        XCTAssert(PathPattern.pathFour.patternToPath(with: ["objectId":"4","sub":"test"]) == "/api/model/4/sub/rel/test")
        XCTAssert(PathPattern.pathFive.patternToPath(with: ["userId":"5-U-12","sub":"test2"]) == "/api/sub/test2/users/5-U-12/el/rel")
    }
    
    func testStringInitializable() {
        struct Model: Decodable {
            let value: Int?
            let secondValue: Int
            let thirdValue: Int
            let fourthValue: Int?
            
            enum CodingKeys: String, CodingKey {
                case value
                case secondValue
                case thirdValue
                case fourthValue
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                value = try container.decodeUnstable(forKey: .value)
                secondValue = try container.decodeUnstable(forKey: .secondValue)
                thirdValue = try container.decodeUnstable(forKey: .thirdValue)
                fourthValue = try container.decodeUnstable(forKey: .fourthValue)
            }
        }
        
        let json = """
        {
            "value": "123",
            "secondValue": "434234434",
            "thirdValue": 777,
            "fourthValue": 2
        }
        """.data(using: .utf8)!
        
        do {
            let decoder = JSONDecoder()
            let test = try decoder.decode(Model.self, from: json)
            print(test)
            XCTAssert(test.value == 123, "value:\(String(describing: test.value)) is wrong")
            XCTAssert(test.secondValue == 434234434, "value:\(test.secondValue) is wrong")
            XCTAssert(test.thirdValue == 777, "value:\(test.thirdValue) is wrong")
            XCTAssert(test.fourthValue == 2, "value:\(String(describing: test.fourthValue)) is wrong")
        } catch {
            print(error)
            XCTFail()
        }
    }
}


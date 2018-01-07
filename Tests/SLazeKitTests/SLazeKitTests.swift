import XCTest
@testable import SLazeKit

struct Configuration: LazeConfiguration {
    static var basePath: String? { return "www.yourdomain.com" }
    static var basePort: Int? { return 8765  }
    static var decoder: JSONDecoder { return JSONDecoder() }
    static var urlSession: URLSession { return URLSession.shared }
    
    static func setup(_ request: URLRequest) -> URLRequest {
        var request: URLRequest = request
        request.setValue("Your token", forHTTPHeaderField: "X-Access-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    static func handle(_ response: HTTPURLResponse?) {
        if response?.statusCode == 401 {
            print("unauthorised")
        }
    }
}

class SLazeKitTests: XCTestCase {
    static var allTests = [
        ("testBasePath", testBasePath),
        ("testBasePort", testBasePort),
    ]
    
    func testBasePath() {
        XCTAssertTrue(Configuration.basePath == "www.yourdomain.com")
    }
    
    func testBasePort() {
        XCTAssertTrue(Configuration.basePort == 8765)
    }
}

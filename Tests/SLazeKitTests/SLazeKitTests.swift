import XCTest
@testable import SLazeKit

extension SLazeKit {
    open class var basePath: String? { return "www.yourdomain.com" }
    open class var basePort: Int? { return 8765  }
    open class var decoder: JSONDecoder { return JSONDecoder() }
    open class var urlSession: URLSession { return URLSession.shared }
    
    open class func setup(_ request: URLRequest) -> URLRequest {
        var request: URLRequest = request
        request.setValue("Your token", forHTTPHeaderField: "X-Access-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    open class func handle(_ response: HTTPURLResponse?) {
        if response?.statusCode == 401 {
            print("unauthorised")
        }
    }
}

class SLazeKitTests: XCTestCase {
    static var allTests = [
        ("testBasePort", testBasePort),
    ]
    
    func testBasePath() {
        XCTAssertTrue(SLazeKit.basePath == "www.yourdomain.com")
    }
    
    func testBasePort() {
        XCTAssertTrue(SLazeKit.basePort == 8765)
    }
}

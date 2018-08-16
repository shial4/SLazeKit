import Foundation
import XCTest
@testable import SLazeKit

struct Configuration: LazeConfiguration {
    static var basePath: String? { return "www.yourdomain.com" }
    static var basePort: Int? { return 8765  }
    static var decoder: JSONDecoder { return JSONDecoder() }
    static var urlSession: URLSession { return URLSession.shared }
    
    static func setup(_ request: URLRequest) -> URLRequest? {
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
        ("testRequestSetup", testRequestSetup),
    ]
    
    func testBasePath() {
        XCTAssertTrue(Configuration.basePath == "www.yourdomain.com")
    }
    
    func testBasePort() {
        XCTAssertTrue(Configuration.basePort == 8765)
    }
    
    func testRequestSetup() {
        let request = Configuration.setup(URLRequest(url: URL(string: "www.yourdomain.com")!))
        XCTAssertTrue(request?.allHTTPHeaderFields?["X-Access-Token"] == "Your token")
        XCTAssertTrue(request?.allHTTPHeaderFields?["Content-Type"] == "application/json")
    }
}

import Foundation
import CoreData

public typealias EntityMappingDecodable = EntityMapping & Decodable

@available(iOS 10.0, *)
extension EntityMapping {
    public static var persistentContainer: NSPersistentContainer? { return nil }
}

//MARK: URLSession class variables
extension URLSession {
    open class var basePath: String? {
        return nil
    }
    
    open class var basePort: Int? {
        return nil
    }
    
    open class var token: String {
        return ""
    }
    
    open class var decoder: JSONDecoder {
        return JSONDecoder()
    }
    
    open class var urlSession: URLSession {
        return URLSession.shared
    }
    
    open class func setup(_ request: URLRequest) -> URLRequest {
        return request
    }
    
    open class func handle(_ response: HTTPURLResponse?) {}
}

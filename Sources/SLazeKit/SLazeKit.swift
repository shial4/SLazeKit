import Foundation
import CoreData

public typealias EntityMappingCodable = EntityMapping & Codable
public typealias EntityMappingDecodable = EntityMapping & Decodable

/// NetworkResponse tuple holding response `Data` and `HTTPURLResponse`
public typealias NetworkResponse = (data: Data?, urlResponse: HTTPURLResponse?)

/// HTTPMethod types
public enum HTTPMethod {
    case GET, POST, PUT, PATCH, DELETE, COPY, HEAD, OPTIONS, LINK, UNLINK, PURGE, LOCK, UNLOCK, PROPFIND, VIEW
}

/// SLazeKit is an easy to use restful collection of extensions and classes. Maps your rest api request into models and provides coredata serialization.
public class SLazeKit {
    /// Provide base path for your API requests.
    open class var basePath: String? { return nil }
    /// Additional you can set port for your requests.
    open class var basePort: Int? { return nil }
    /// Optional provider for JSONDecoder instance.
    open class var decoder: JSONDecoder { return JSONDecoder() }
    /// Optional provider for JSONDecoder instance.
    open class var urlSession: URLSession { return URLSession.shared }
    
    /// Global outgoing `URLRequest` customization. Called everytime request is created before executed.
    ///
    /// - Parameter request: `URLRequest` object to setup
    /// - Returns: already setup and customize URLRequest object
    open class func setup(_ request: URLRequest) -> URLRequest { return request }
    open class func handle(_ response: HTTPURLResponse?) {}
    
    /// Required override of this method which will provide Context for bacground execution.
    ///
    /// - Returns: NSManagedObjectContext
    open class func newBackgroundContext() -> NSManagedObjectContext? { return nil }
    
    class func networkTask(request: URLRequest, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        let task = urlSession.dataTask(with: setup(request)) { (data, response, error) in
            handle(response as? HTTPURLResponse)
            handler((data, response as? HTTPURLResponse), error)
        }
        task.resume()
        return task
    }
    
    class func networkTask<T: Decodable>(request: URLRequest, handler: @escaping (_ response: NetworkResponse, _ result: T?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        let task = urlSession.dataTask(with: setup(request)) { (data, response, error) in
            handle(response as? HTTPURLResponse)
            if let data = data, error == nil {
                do {
                    let object = try decoder.decode(T.self, from: data)
                    try synchronize(object)
                    handler((data, response as? HTTPURLResponse), object, nil)
                } catch {
                    handler((data, response as? HTTPURLResponse), nil, error)
                }
            } else {
                handler((data, response as? HTTPURLResponse), nil, error)
            }
        }
        task.resume()
        return task
    }
    
    class func networkTask(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, body: String, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler((nil,nil), NSError(domain: "Unable to get url from components", code: NSURLErrorBadURL, userInfo: nil))
            return nil
        }
        
        var request = urlRequest(url, method: method)
        request.httpBody = body.data(using: .utf8)
        return networkTask(request: request, handler: handler)
    }
    
    class func networkTask<B: Encodable>(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, body: B, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler((nil,nil), NSError(domain: "Unable to get url from components", code: NSURLErrorBadURL, userInfo: nil))
            return nil
        }
        
        var request = urlRequest(url, method: method)
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            handler((nil,nil), error)
            return nil
        }
        
        return networkTask(request: request, handler: handler)
    }
    
    class func networkTask<T: Decodable>(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, body: String, handler: @escaping (_ response: NetworkResponse, _ result: T?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler((nil,nil), nil, NSError(domain: "Unable to get url from components", code: NSURLErrorBadURL, userInfo: nil))
            return nil
        }
        
        var request = urlRequest(url, method: method)
        request.httpBody = body.data(using: .utf8)
        
        return networkTask(request: request, handler: handler)
    }
    
    class func networkTask<T: Decodable, B: Encodable>(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, body: B, handler: @escaping (_ response: NetworkResponse, _ result: T?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler((nil,nil), nil, NSError(domain: "Unable to get url from components", code: NSURLErrorBadURL, userInfo: nil))
            return nil
        }
        
        var request = urlRequest(url, method: method)
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            handler((nil,nil), nil, error)
            return nil
        }
        
        return networkTask(request: request, handler: handler)
    }
    
    class func networkTask<B: Encodable>(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, body: [B], handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler((nil,nil), NSError(domain: "Unable to get url from components", code: NSURLErrorBadURL, userInfo: nil))
            return nil
        }
        
        var request = urlRequest(url, method: method)
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            handler((nil,nil), error)
            return nil
        }
        
        return networkTask(request: request, handler: handler)
    }
    
    class func networkTask<T: Decodable, B: Encodable>(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, body: [B], handler: @escaping (_ response: NetworkResponse, _ result: T?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler((nil,nil), nil, NSError(domain: "Unable to get url from components", code: NSURLErrorBadURL, userInfo: nil))
            return nil
        }
        
        var request = urlRequest(url, method: method)
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            handler((nil,nil), nil, error)
            return nil
        }
        
        return networkTask(request: request, handler: handler)
    }
    
    class func networkTask(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler((nil,nil), NSError(domain: "Unable to get url from components", code: NSURLErrorBadURL, userInfo: nil))
            return nil
        }
        return networkTask(request: urlRequest(url, method: method), handler: handler)
    }
    
    class func networkTask<T: Decodable>(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: T?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler((nil,nil), nil, NSError(domain: "Unable to get url from components", code: NSURLErrorBadURL, userInfo: nil))
            return nil
        }
        return networkTask(request: urlRequest(url, method: method), handler: handler)
    }
    
    private class func urlRequest(_ url: URL, method: HTTPMethod?) -> URLRequest {
        var request = URLRequest(url: url)
        if let httpMethod = method {
            request.httpMethod = String(describing: httpMethod)
        }
        return request
    }
    
    private class func components(for path: String, queryItems: [URLQueryItem]?) -> URLComponents? {
        var urlComponents = URLComponents(string: (basePath ?? "") + path)
        urlComponents?.port = basePort
        urlComponents?.queryItems = queryItems
        return urlComponents
    }
    
    private class func synchronize(_ obj: Any) throws {
        guard let context = newBackgroundContext() else { return }
        if let array = obj as? [EntityMapping] {
            array.forEach({_ = try? $0.map(context)})
        } else {
            guard let mapper = obj as? EntityMapping else { return }
            _ = try mapper.map(context)
        }
        context.commit()
    }
}

extension SLazeKit {
    public class func request(path: String, method: HTTPMethod, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: method, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func request<T: Encodable>(path: String, method: HTTPMethod, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: method, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func request<T: Encodable>(path: String, method: HTTPMethod, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: method, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func request(path: String, method: HTTPMethod, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: method, queryItems: queryItems, handler: handler)
    }
    
    public class func get(path: String, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func get<T: Encodable>(path: String, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func get<T: Encodable>(path: String, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func get(path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, queryItems: queryItems, handler: handler)
    }
    
    public class func post(path: String, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .POST, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func post<T: Encodable>(path: String, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .POST, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func post<T: Encodable>(path: String, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .POST, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func post(path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .POST, queryItems: queryItems, handler: handler)
    }
    
    public class func put(path: String, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .PUT, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func put<T: Encodable>(path: String, queryItems: [URLQueryItem]? = nil, body: T, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .PUT, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func put<T: Encodable>(path: String, queryItems: [URLQueryItem]? = nil, body: [T], handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .PUT, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func put(path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .PUT, queryItems: queryItems, handler: handler)
    }
    
    public class func patch(path: String, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .PATCH, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func patch<T: Encodable>(path: String, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .PATCH, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func patch<T: Encodable>(path: String, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .PATCH, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func patch(path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .PATCH, queryItems: queryItems, handler: handler)
    }
    
    public class func delete(path: String, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .DELETE, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func delete<T: Encodable>(path: String, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .DELETE, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func delete<T: Encodable>(path: String, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .DELETE, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func delete(path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .DELETE, queryItems: queryItems, handler: handler)
    }
}

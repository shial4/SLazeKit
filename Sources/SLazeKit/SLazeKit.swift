import Foundation
import CoreData

public typealias EntityMappingDecodable = EntityMapping & Decodable

public enum HTTPMethod {
    case GET, POST, PUT, PATCH, DELETE, COPY, HEAD, OPTIONS, LINK, UNLINK, PURGE, LOCK, UNLOCK, PROPFIND, VIEW
}

@available(iOS 10.0, *)
extension EntityMapping {
    public static var persistentContainer: NSPersistentContainer? { return nil }
}

public class SLazeKit {
    open class var basePath: String? { return nil }
    open class var basePort: Int? { return nil }
    open class var decoder: JSONDecoder { return JSONDecoder() }
    open class var urlSession: URLSession { return URLSession.shared }
    
    open class func setup(_ request: URLRequest) -> URLRequest { return request }
    open class func handle(_ response: HTTPURLResponse?) {}
}

//MARK: network tasks implementation
extension SLazeKit {
    class func networkTask(request: URLRequest, handler: @escaping (_ response: HTTPURLResponse?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        let task = urlSession.dataTask(with: setup(request)) { (data, response, error) in
            handle(response as? HTTPURLResponse)
            handler(response as? HTTPURLResponse, error)
        }
        task.resume()
        return task
    }
    
    class func networkTask<T: Decodable>(request: URLRequest, handler: @escaping (_ response: HTTPURLResponse?, _ result: T?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        let task = urlSession.dataTask(with: setup(request)) { (data, response, error) in
            handle(response as? HTTPURLResponse)
            if let data = data, error == nil {
                do {
                    let object = try decoder.decode(T.self, from: data)
                    if #available(iOS 10.0, *) {
                        try synchronize(object)
                    }
                    handler(response as? HTTPURLResponse, object, nil)
                } catch {
                    handler(response as? HTTPURLResponse, nil, error)
                }
            } else {
                handler(response as? HTTPURLResponse, nil, error)
            }
        }
        task.resume()
        return task
    }
    
    class func networkTask<B: Encodable>(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, body: B, handler: @escaping (_ response: HTTPURLResponse?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler(nil, NSError(domain: "Unable to get url from components", code: NSURLErrorBadURL, userInfo: nil))
            return nil
        }
        
        var request = urlRequest(url, method: method)
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            handler(nil, error)
            return nil
        }
        
        return networkTask(request: request, handler: handler)
    }
    
    class func networkTask<T: Decodable, B: Encodable>(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, body: B, handler: @escaping (_ response: HTTPURLResponse?, _ result: T?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler(nil, nil, NSError(domain: "Unable to get url from components", code: NSURLErrorBadURL, userInfo: nil))
            return nil
        }
        
        var request = urlRequest(url, method: method)
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            handler(nil, nil, error)
            return nil
        }
        
        return networkTask(request: request, handler: handler)
    }
    
    class func networkTask<B: Encodable>(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, body: [B], handler: @escaping (_ response: HTTPURLResponse?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler(nil, NSError(domain: "Unable to get url from components", code: NSURLErrorBadURL, userInfo: nil))
            return nil
        }
        
        var request = urlRequest(url, method: method)
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            handler(nil, error)
            return nil
        }
        
        return networkTask(request: request, handler: handler)
    }
    
    class func networkTask<T: Decodable, B: Encodable>(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, body: [B], handler: @escaping (_ response: HTTPURLResponse?, _ result: T?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler(nil, nil, NSError(domain: "Unable to get url from components", code: NSURLErrorBadURL, userInfo: nil))
            return nil
        }
        
        var request = urlRequest(url, method: method)
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            handler(nil, nil, error)
            return nil
        }
        
        return networkTask(request: request, handler: handler)
    }
    
    class func networkTask(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: HTTPURLResponse?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler(nil, NSError(domain: "Unable to get url from components", code: NSURLErrorBadURL, userInfo: nil))
            return nil
        }
        return networkTask(request: urlRequest(url, method: method), handler: handler)
    }
    
    class func networkTask<T: Decodable>(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: HTTPURLResponse?, _ result: T?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler(nil, nil, NSError(domain: "Unable to get url from components", code: NSURLErrorBadURL, userInfo: nil))
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
}

//MARK: CoreData mapping support
extension SLazeKit {
    @available(iOS 10.0, *)
    fileprivate class func synchronize(_ obj: Any) throws {
        if let array = obj as? [EntityMapping] {
            array.forEach({_ = try? $0.map()})
        } else {
            guard let mapper = obj as? EntityMapping else { return }
            _ = try mapper.map()
        }
    }
}

extension SLazeKit {
    public class func request<T: Encodable>(path: String, method: HTTPMethod, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: HTTPURLResponse?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: method, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func request<T: Encodable>(path: String, method: HTTPMethod, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: HTTPURLResponse?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: method, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func request(path: String, method: HTTPMethod, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: HTTPURLResponse?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: method, queryItems: queryItems, handler: handler)
    }
    
    public class func get<T: Encodable>(path: String, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: HTTPURLResponse?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func get<T: Encodable>(path: String, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: HTTPURLResponse?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func get(path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: HTTPURLResponse?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, queryItems: queryItems, handler: handler)
    }
    
    public class func post<T: Encodable>(path: String, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: HTTPURLResponse?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .POST, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func post<T: Encodable>(path: String, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: HTTPURLResponse?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .POST, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func post(path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: HTTPURLResponse?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .POST, queryItems: queryItems, handler: handler)
    }
    
    public class func put<T: Encodable>(path: String, queryItems: [URLQueryItem]? = nil, body: T, handler: @escaping (_ response: HTTPURLResponse?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .PUT, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func put<T: Encodable>(path: String, queryItems: [URLQueryItem]? = nil, body: [T], handler: @escaping (_ response: HTTPURLResponse?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .PUT, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func put(path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: HTTPURLResponse?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .PUT, queryItems: queryItems, handler: handler)
    }
    
    public class func delete<T: Encodable>(path: String, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: HTTPURLResponse?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .DELETE, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func delete<T: Encodable>(path: String, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: HTTPURLResponse?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .DELETE, queryItems: queryItems, body: body, handler: handler)
    }
    
    public class func delete(path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: HTTPURLResponse?, _ error: Error?) -> ()) -> URLSessionDataTask? {
        return SLazeKit.networkTask(path: path, method: .DELETE, queryItems: queryItems, handler: handler)
    }
}

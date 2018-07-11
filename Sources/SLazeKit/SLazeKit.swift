import Foundation

/// NetworkResponse tuple holding response `Data` and `HTTPURLResponse`
public typealias NetworkResponse = (data: Data?, http: HTTPURLResponse?)

/// HTTPMethod types
public enum HTTPMethod {
    case GET, POST, PUT, PATCH, DELETE, COPY, HEAD, OPTIONS, LINK, UNLINK, PURGE, LOCK, UNLOCK, PROPFIND, VIEW
}

/// SLazeKit is an easy to use restful collection of extensions and classes. Maps your rest api request into models and provides serialization of your extension choice.
public class SLazeKit<Config: LazeConfiguration> {
    class func networkTask(request: URLRequest, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        guard let req = Config.setup(request) else {
            handler((nil,nil), NSError(domain: "", code: NSURLErrorCancelled,
                                       userInfo: ["reason":"Client config return nil request"]))
            return nil
        }
        let task = Config.urlSession.dataTask(with: req) { (data, response, error) in
            Config.handle(response as? HTTPURLResponse)
            handler((data, response as? HTTPURLResponse), error)
        }
        task.resume()
        return task
    }
    
    class func networkTask<T: Decodable>(request: URLRequest, handler: @escaping (_ response: NetworkResponse, _ result: T?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        guard let req = Config.setup(request) else {
            handler((nil,nil),nil, NSError(domain: "", code: NSURLErrorCancelled,
                                       userInfo: ["reason":"Client config return nil request"]))
            return nil
        }
        let task = Config.urlSession.dataTask(with: req) { (data, response, error) in
            Config.handle(response as? HTTPURLResponse)
            if let data = data, error == nil {
                do {
                    let object = try Config.decoder.decode(T.self, from: data)
                    Config.synchronize(object)
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
    
    class func networkTask(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, body: String, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler((nil,nil), urlConstructError(path, method, queryItems, body))
            return nil
        }
        
        var request = urlRequest(url, method: method)
        request.httpBody = body.data(using: .utf8)
        return networkTask(request: request, handler: handler)
    }
    
    class func networkTask<B: Encodable>(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, body: B, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler((nil,nil), urlConstructError(path, method, queryItems, body))
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
    
    class func networkTask<T: Decodable>(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, body: String, handler: @escaping (_ response: NetworkResponse, _ result: T?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler((nil,nil), nil, urlConstructError(path, method, queryItems, body))
            return nil
        }
        
        var request = urlRequest(url, method: method)
        request.httpBody = body.data(using: .utf8)
        
        return networkTask(request: request, handler: handler)
    }
    
    class func networkTask<T: Decodable, B: Encodable>(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, body: B, handler: @escaping (_ response: NetworkResponse, _ result: T?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler((nil,nil), nil, urlConstructError(path, method, queryItems, body))
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
    
    class func networkTask<B: Encodable>(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, body: [B], handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler((nil,nil), urlConstructError(path, method, queryItems, body))
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
    
    class func networkTask<T: Decodable, B: Encodable>(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, body: [B], handler: @escaping (_ response: NetworkResponse, _ result: T?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler((nil,nil), nil, urlConstructError(path, method, queryItems, body))
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
    
    class func networkTask(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler((nil,nil), urlConstructError(path, method, queryItems, nil))
            return nil
        }
        return networkTask(request: urlRequest(url, method: method), handler: handler)
    }
    
    class func networkTask<T: Decodable>(path: String, method: HTTPMethod? = nil, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: T?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        guard let url = components(for: path, queryItems: queryItems)?.url else {
            handler((nil,nil), nil, urlConstructError(path, method, queryItems, nil))
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
        var urlComponents = URLComponents(string: (Config.basePath ?? "") + path)
        urlComponents?.port = Config.basePort
        urlComponents?.queryItems = queryItems
        return urlComponents
    }
    
    private class func urlConstructError(_ path: String, _ method: HTTPMethod? = nil, _ queryItems: [URLQueryItem]? = nil, _ body: Any?) -> NSError {
        return NSError(domain: "", code: NSURLErrorBadURL,
                       userInfo: ["path":path,
                                  "method":"\(method ?? .GET)",
                        "queryItems":"\(queryItems ?? [])",
                        "body":String(describing: body)])
    }
}

extension SLazeKit {
    final public class func request(path: String, method: HTTPMethod, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, method: method, queryItems: queryItems, body: body, handler: handler)
    }
    
    final public class func request<T: Encodable>(path: String, method: HTTPMethod, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, method: method, queryItems: queryItems, body: body, handler: handler)
    }
    
    final public class func request<T: Encodable>(path: String, method: HTTPMethod, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, method: method, queryItems: queryItems, body: body, handler: handler)
    }
    
    final public class func request(path: String, method: HTTPMethod, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, method: method, queryItems: queryItems, handler: handler)
    }
    
    final public class func get(path: String, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, queryItems: queryItems, body: body, handler: handler)
    }
    
    final public class func get<T: Encodable>(path: String, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, queryItems: queryItems, body: body, handler: handler)
    }
    
    final public class func get<T: Encodable>(path: String, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, queryItems: queryItems, body: body, handler: handler)
    }
    
    final public class func get(path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, queryItems: queryItems, handler: handler)
    }
    
    final public class func post(path: String, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, method: .POST, queryItems: queryItems, body: body, handler: handler)
    }
    
    final public class func post<T: Encodable>(path: String, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, method: .POST, queryItems: queryItems, body: body, handler: handler)
    }
    
    final public class func post<T: Encodable>(path: String, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, method: .POST, queryItems: queryItems, body: body, handler: handler)
    }
    
    final public class func post(path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, method: .POST, queryItems: queryItems, handler: handler)
    }
    
    final public class func put(path: String, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, method: .PUT, queryItems: queryItems, body: body, handler: handler)
    }
    
    final public class func put<T: Encodable>(path: String, queryItems: [URLQueryItem]? = nil, body: T, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, method: .PUT, queryItems: queryItems, body: body, handler: handler)
    }
    
    final public class func put<T: Encodable>(path: String, queryItems: [URLQueryItem]? = nil, body: [T], handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, method: .PUT, queryItems: queryItems, body: body, handler: handler)
    }
    
    final public class func put(path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, method: .PUT, queryItems: queryItems, handler: handler)
    }
    
    final public class func patch(path: String, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, method: .PATCH, queryItems: queryItems, body: body, handler: handler)
    }
    
    final public class func patch<T: Encodable>(path: String, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, method: .PATCH, queryItems: queryItems, body: body, handler: handler)
    }
    
    final public class func patch<T: Encodable>(path: String, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, method: .PATCH, queryItems: queryItems, body: body, handler: handler)
    }
    
    final public class func patch(path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, method: .PATCH, queryItems: queryItems, handler: handler)
    }
    
    final public class func delete(path: String, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, method: .DELETE, queryItems: queryItems, body: body, handler: handler)
    }
    
    final public class func delete<T: Encodable>(path: String, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, method: .DELETE, queryItems: queryItems, body: body, handler: handler)
    }
    
    final public class func delete<T: Encodable>(path: String, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, method: .DELETE, queryItems: queryItems, body: body, handler: handler)
    }
    
    final public class func delete(path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return networkTask(path: path, method: .DELETE, queryItems: queryItems, handler: handler)
    }
}

import Foundation

extension Decodable {
    public static func request(path: String, method: HTTPMethod, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, method: method, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func request<T: Encodable>(path: String, method: HTTPMethod, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, method: method, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func request<T: Encodable>(path: String, method: HTTPMethod, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, method: method, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func request(path: String, method: HTTPMethod, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, method: method, queryItems: queryItems, handler: handler)
    }
    
    public static func get(path: String, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func get<T: Encodable>(path: String, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func get<T: Encodable>(path: String, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func get(path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, queryItems: queryItems, handler: handler)
    }
    
    public static func post(path: String, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, method: .POST, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func post<T: Encodable>(path: String, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, method: .POST, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func post<T: Encodable>(path: String, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, method: .POST, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func post(path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, method: .POST, queryItems: queryItems, handler: handler)
    }
    
    public static func put(path: String, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, method: .PUT, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func put<T: Encodable>(path: String, queryItems: [URLQueryItem]? = nil, body: T, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, method: .PUT, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func put<T: Encodable>(path: String, queryItems: [URLQueryItem]? = nil, body: [T], handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, method: .PUT, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func put(path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, method: .PUT, queryItems: queryItems, handler: handler)
    }
    
    public static func patch(path: String, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, method: .PATCH, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func patch<T: Encodable>(path: String, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, method: .PATCH, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func patch<T: Encodable>(path: String, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, method: .PATCH, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func patch(path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, method: .PATCH, queryItems: queryItems, handler: handler)
    }
    
    public static func delete(path: String, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, method: .DELETE, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func delete<T: Encodable>(path: String, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, method: .DELETE, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func delete<T: Encodable>(path: String, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, method: .DELETE, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func delete(path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<Default>.networkTask(path: path, method: .DELETE, queryItems: queryItems, handler: handler)
    }
}

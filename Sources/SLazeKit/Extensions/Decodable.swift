import Foundation

extension Decodable {
    public static func request<C: LazeConfiguration>(config: C.Type, path: String, method: HTTPMethod, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, method: method, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func request<C: LazeConfiguration, T: Encodable>(config: C.Type, path: String, method: HTTPMethod, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, method: method, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func request<C: LazeConfiguration, T: Encodable>(config: C.Type, path: String, method: HTTPMethod, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, method: method, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func request<C: LazeConfiguration>(config: C.Type, path: String, method: HTTPMethod, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, method: method, queryItems: queryItems, handler: handler)
    }
    
    public static func get<C: LazeConfiguration>(config: C.Type, path: String, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func get<C: LazeConfiguration, T: Encodable>(config: C.Type, path: String, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func get<C: LazeConfiguration, T: Encodable>(config: C.Type, path: String, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func get<C: LazeConfiguration>(config: C.Type, path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, queryItems: queryItems, handler: handler)
    }
    
    public static func post<C: LazeConfiguration>(config: C.Type, path: String, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, method: .POST, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func post<C: LazeConfiguration, T: Encodable>(config: C.Type, path: String, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, method: .POST, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func post<C: LazeConfiguration, T: Encodable>(config: C.Type, path: String, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, method: .POST, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func post<C: LazeConfiguration>(config: C.Type, path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, method: .POST, queryItems: queryItems, handler: handler)
    }
    
    public static func put<C: LazeConfiguration>(config: C.Type, path: String, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, method: .PUT, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func put<C: LazeConfiguration, T: Encodable>(config: C.Type, path: String, queryItems: [URLQueryItem]? = nil, body: T, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, method: .PUT, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func put<C: LazeConfiguration, T: Encodable>(config: C.Type, path: String, queryItems: [URLQueryItem]? = nil, body: [T], handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, method: .PUT, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func put<C: LazeConfiguration>(config: C.Type, path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, method: .PUT, queryItems: queryItems, handler: handler)
    }
    
    public static func patch<C: LazeConfiguration>(config: C.Type, path: String, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, method: .PATCH, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func patch<C: LazeConfiguration, T: Encodable>(config: C.Type, path: String, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, method: .PATCH, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func patch<C: LazeConfiguration, T: Encodable>(config: C.Type, path: String, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, method: .PATCH, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func patch<C: LazeConfiguration>(config: C.Type, path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, method: .PATCH, queryItems: queryItems, handler: handler)
    }
    
    public static func delete<C: LazeConfiguration>(config: C.Type, path: String, body: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, method: .DELETE, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func delete<C: LazeConfiguration, T: Encodable>(config: C.Type, path: String, body: T, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, method: .DELETE, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func delete<C: LazeConfiguration, T: Encodable>(config: C.Type, path: String, body: [T], queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, method: .DELETE, queryItems: queryItems, body: body, handler: handler)
    }
    
    public static func delete<C: LazeConfiguration>(config: C.Type, path: String, queryItems: [URLQueryItem]? = nil, handler: @escaping (_ response: NetworkResponse, _ result: Self?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return SLazeKit<C>.networkTask(path: path, method: .DELETE, queryItems: queryItems, handler: handler)
    }
}

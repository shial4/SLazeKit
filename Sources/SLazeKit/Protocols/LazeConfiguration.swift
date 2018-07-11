//
//  LazeConfiguration.swift
//  SLazeKit
//
//  Created by Shial on 8/1/18.
//

import Foundation

/// LazeConfiguration protocol represents API configuration 
public protocol LazeConfiguration {
    /// Provide base path for your API requests.
    static var basePath: String? { get }
    /// Additional you can set port for your requests.
    static var basePort: Int? { get }
    /// Optional provider for JSONDecoder instance.
    static var decoder: JSONDecoder { get }
    /// Optional provider for JSONDecoder instance.
    static var urlSession: URLSession { get }
    
    /// Global outgoing `URLRequest` customization. Called everytime request is created before executed.
    ///
    /// - Parameter request: `URLRequest` object to setup
    /// - Returns: already setup and customize URLRequest object
    static func setup(_ request: URLRequest) -> URLRequest?
    
    /// Global handler for `HTTPURLResponse`. Called everytime response is capture.
    ///
    /// - Parameter request: `HTTPURLResponse` object to handle
    static func handle(_ response: HTTPURLResponse?)
    
    
    /// Method dedicated to be use for synchronize object into persisten store
    ///
    /// - Parameter obj: encoded object
    /// - Throws: error occured during the process
    static func synchronize(_ obj: Any)
}

extension LazeConfiguration {
    public static var basePort: Int? { return nil }
    public static var decoder: JSONDecoder { return JSONDecoder() }
    public static var urlSession: URLSession { return URLSession.shared }
    
    public static func setup(_ request: URLRequest) -> URLRequest { return request }
    public static func handle(_ response: HTTPURLResponse?) {}
    
    public static func synchronize(_ obj: Any) {}
}

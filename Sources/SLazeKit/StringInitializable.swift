import Foundation

public protocol StringInitializable {
    init?(rawValue: String)
}

extension Int: StringInitializable {
    public init?(rawValue: String) {
        guard let value = Int(rawValue) else {
            return nil
        }
        self = value
    }
}

extension Double: StringInitializable {
    public init?(rawValue: String) {
        guard let value = Double(rawValue) else {
            return nil
        }
        self = value
    }
}

extension KeyedDecodingContainerProtocol {
    public func decodeUnstable<T: Decodable & StringInitializable>(_ type: T.Type = T.self, forKey key: Key) throws -> T? {
        guard contains(key) else {
            return nil
        }
        guard !(try decodeNil(forKey: key)) else {
            return nil
        }
        if let string = try? decode(String.self, forKey: key) {
            guard let value = T.init(rawValue: string) else {
                throw DecodingError.dataCorruptedError(forKey: key,
                                                       in: self,
                                                       debugDescription: "Found string that cannot be converted to \(T.self)")
            }
            return value
        }
        return try decode(T.self, forKey: key)
    }
    public func decodeUnstable<T: Decodable & StringInitializable>(_ type: T.Type = T.self, forKey key: Key) throws -> T {
        if let string = try? decode(String.self, forKey: key) {
            guard let value = T.init(rawValue: string) else {
                throw DecodingError.dataCorruptedError(forKey: key,
                                                       in: self,
                                                       debugDescription: "Found string that cannot be converted to \(T.self)")
            }
            return value
        }
        return try decode(T.self, forKey: key)
    }
}

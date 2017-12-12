import Foundation

extension String {
    public func patternToPath(with arguments: [String : String] = [:]) -> String {
        var path = self
        for (key, value) in arguments {
            path = path.replacingOccurrences(of: ":\(key)", with: value)
        }
        return path
    }
}

import Foundation

extension String {
    /// Replace string patter keys with values. For example:
    ///
    /// in pattern `"/api/path/:id"`
    ///
    /// `["id":"\(123-XYZ-321)"]` `:id` key would be replaced with `"\(123-XYZ-321)"` value.
    ///
    /// - Parameter arguments: Dictionary with key & value to replace.
    /// - Returns: Path with values instead of keys.
    public func patternToPath(with arguments: [String : String] = [:]) -> String {
        var path = self
        for (key, value) in arguments {
            path = path.replacingOccurrences(of: ":\(key)", with: value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? value)
        }
        return path
    }
}

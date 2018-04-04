import Foundation
import CoreData

/// Entity attribute alias for key, value tuple.
public typealias EntityAttribute = (key: String, value: Any)

/// Mapping protocol. Required for request object serialization.
public protocol EntityMapping {
    static var entityType: NSManagedObject.Type { get }
    var idAttributes: [EntityAttribute]? { get }
    func fillObject(with model: NSManagedObject)
}

extension EntityMapping {
    func map(_ context: NSManagedObjectContext) throws -> NSManagedObject? {
        var model: NSManagedObject? = nil
        var mapError: Error?
        context.performAndWait {
            do {
                if let attribiutes = idAttributes {
                    model = try Self.entityType.find(context, by: attribiutes) ?? Self.entityType.init(context: context)
                } else {
                    model = try findObject(context) ?? Self.entityType.init(context: context)
                }
                if let object = model {
                    fillObject(with: object)
                }
            } catch {
                mapError = error
            }
        }
        if let error = mapError {
            throw error
        }
        return model
    }
    
    private func findObject(_ context: NSManagedObjectContext?) throws -> NSManagedObject? {
        return try Self.entityType.find(context, by: idAttributes ?? [])
    }
    
    /// Serialized managed object from datastore by given attribiutes. To be more specific. If request is returning JSON with `EntityMapping` and given Encodable object conform to this protocol. It will be automaticaly updated in DataStore. This method featch this object.
    ///
    /// - Parameter context: Context on which fetch should be executed
    /// - Returns: Serialized object from EntityMapping model
    public func serialized<T: NSManagedObject>(_ context: NSManagedObjectContext?) throws -> T? {
        return (try Self.entityType.find(context, by: idAttributes ?? [])) as? T
    }
}

extension Array where Element: EntityMapping {
    /// Serialized managed objects from datastore by given attribiutes. To be more specific. If request is returning JSON with `EntityMapping` and given Encodable object conform to this protocol. It will be automaticaly updated in DataStore. This method featch this objects.
    ///
    /// - Parameter context: Context on which fetch should be executed
    /// - Returns: Array of serialized object from EntityMapping response type.
    public func serialized<T: NSManagedObject>(_ context: NSManagedObjectContext?) throws -> [T] {
        return try compactMap({ try $0.serialized(context) })
    }
}



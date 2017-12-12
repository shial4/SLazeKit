import Foundation
import CoreData

public typealias EntityAttribute = (key: String, value: Any)

public protocol EntityMapping {
    static var entityType: NSManagedObject.Type { get }
    var idAttributes: [EntityAttribute]? { get }
    func fillObject(with model: NSManagedObject)
}

@available(iOS 10.0, *)
extension EntityMapping {
    func map() throws -> NSManagedObject? {
        guard let context = Self.persistentContainer?.newBackgroundContext() else { return nil }
        let model: NSManagedObject
        if let attribiutes = idAttributes {
            model = try Self.entityType.find(context, by: attribiutes) ?? Self.entityType.init(context: context)
        } else {
            model = try findObject(context) ?? Self.entityType.init(context: context)
        }
        fillObject(with: model)
        context.performAndWait { context.commit() }
        return model
    }
    
    private func findObject(_ context: NSManagedObjectContext?) throws -> NSManagedObject? {
        return try Self.entityType.find(context, by: idAttributes ?? [])
    }
}

extension EntityMapping {
    public func serialized<T: NSManagedObject>(_ context: NSManagedObjectContext?) throws -> T? {
        return (try Self.entityType.find(context, by: idAttributes ?? [])) as? T
    }
}

extension Array where Element: EntityMapping {
    public func serialized<T: NSManagedObject>(_ context: NSManagedObjectContext?) throws -> [T] {
        return try flatMap({ try $0.serialized(context) })
    }
}

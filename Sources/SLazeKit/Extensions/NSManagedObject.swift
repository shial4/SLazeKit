import Foundation
import CoreData

extension NSManagedObject {
    /// String entity name
    final public class var entityName: String? {
        return NSStringFromClass(self).components(separatedBy: ".").last
    }
    /// Finds `NSManagedObject` by EntityAttribute parameters.
    ///
    /// - Parameters:
    ///   - context: Context on which fetch should be executed
    ///   - attributes: Entity attribute mapped by key - value
    /// - Returns: Returns first object that meet the criteria specified by a given fetch request.
    final public class func find(_ context: NSManagedObjectContext?, by attributes: EntityAttribute...) throws -> NSManagedObject? {
        return try find(context, by: attributes.map {$0})
    }
    
    /// Finds `NSManagedObject` by EntityAttribute parameters.
    ///
    /// - Parameters:
    ///   - context: Context on which fetch should be executed
    ///   - attributes: Entity attribute mapped by key - value
    /// - Returns: Returns first object that meet the criteria specified by a given fetch request.
    final public class func find(_ context: NSManagedObjectContext?, by attributes: [EntityAttribute]) throws -> NSManagedObject? {
        guard let name = entityName else { return nil }
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: name)
        var predicates: [NSPredicate] = []
        attributes.forEach({
            predicates.append(NSPredicate(format: "\($0.key) = %@", argumentArray: [$0.value]))
        })
        if !predicates.isEmpty {
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        fetchRequest.fetchLimit = 1
        return try context?.fetch(fetchRequest).first
    }
}

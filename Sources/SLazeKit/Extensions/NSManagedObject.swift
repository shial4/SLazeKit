import Foundation
import CoreData

extension NSManagedObject {
    public class var entityName: String? {
        return NSStringFromClass(self).components(separatedBy: ".").last
    }
    
    class func find(_ context: NSManagedObjectContext?, by attributes: EntityAttribute...) throws -> NSManagedObject? {
        guard let name = entityName else { return nil }
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: name)
        var predicates: [NSPredicate] = []
        attributes.forEach({ predicates.append(NSPredicate(format: "\($0.key) = %@", argumentArray: [$0.value])) })
        if !predicates.isEmpty { fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates) }
        fetchRequest.fetchLimit = 1
        return try context?.fetch(fetchRequest).first
    }
    
    class func find(_ context: NSManagedObjectContext?, by attributes: [EntityAttribute]) throws -> NSManagedObject? {
        guard let name = entityName else { return nil }
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: name)
        var predicates: [NSPredicate] = []
        attributes.forEach({ predicates.append(NSPredicate(format: "\($0.key) = %@", argumentArray: [$0.value])) })
        if !predicates.isEmpty { fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates) }
        fetchRequest.fetchLimit = 1
        return try context?.fetch(fetchRequest).first
    }
}

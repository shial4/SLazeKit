import Foundation
import SLazeKit
import CoreData

class Object: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Object> {
        return NSFetchRequest<Object>(entityName: "Object")
    }
    
    @NSManaged public var id: String
    @NSManaged public var value: Double
    @NSManaged public var name: String?
    
    /// Path pattern for our model API requests
    public struct PathPattern {
        static var model: String { return "/api/Objects/:modelId" }
        static var models: String { return "/api/Objects" }
        static var create: String { return "/api/Objects/:modelId/create" }
        static var delete: String { return "/api/Objects/:modelId/delete" }
    }
    /// We are creating struct which represents Codable object of our API request
    /// `EntityMappingCodable` is required
    public struct ObjectRestful: EntityMappingCodable {
        var id: String
        var value: Double
        var name: String?
        /// We need provide NSManagedObject type for our serialization.
        public static var entityType: NSManagedObject.Type {
            return Object.self
        }
        /// By providing id attributes our model are updated/created/serialized
        public var idAttributes: [EntityAttribute]? {
            return [
                ("id",id)
            ]
        }
        /// init ObjectRestful with our Object clss
        ///
        /// - Parameter model: model of our Object class
        init(with model: Object) {
            self.id = model.id
            self.value = model.value
            self.name = model.name
        }
        
        /// Fill CoreData object with our model response
        public func fillObject(with model: NSManagedObject) {
            guard let object = model as? Object else { return }
            object.id = id
            object.value = value
            object.name = name
        }
    }
}


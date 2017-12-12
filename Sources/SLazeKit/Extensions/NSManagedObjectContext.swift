import Foundation
import CoreData

extension NSManagedObjectContext {
    func commit() {
        if hasChanges {
            do {
                try save()
            } catch {
                print(error)
            }
        }
    }
}

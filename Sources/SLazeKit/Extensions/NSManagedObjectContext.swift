import Foundation
import CoreData

extension NSManagedObjectContext {
    /// Ifthe context has uncommitted changes, attempts to commit unsaved changes to registered objects to the context’s parent store.
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

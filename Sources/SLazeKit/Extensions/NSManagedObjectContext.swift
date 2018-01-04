import Foundation
import CoreData

extension NSManagedObjectContext {
    /// If the context has uncommitted changes, attempts to commit unsaved changes to registered objects to the context’s parent store.
    func commit() {
        self.performAndWait {
            if self.hasChanges {
                do {
                    try save()
                    self.parent?.perform({
                        if self.parent?.hasChanges == true {
                            self.parent?.commit()
                            self.parent?.refreshAllObjects()
                        }
                    })
                } catch {
                    print(error)
                }
            }
        }
    }
}

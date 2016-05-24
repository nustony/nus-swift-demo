//
//  CoreDataManager.h
//  NUS Technology
//
//  Created by NUS Technology on 6/20/14.
//
//
// Manager for core data ( local database )
import Foundation
class CoreDataManager: NSObject {
    // Context for CoreData
    var managedObjectContext: NSManagedObjectContext {
        get {
            if managedObjectContext != nil {
                return managedObjectContext
            }
            var coordinator: NSPersistentStoreCoordinator = self.persistentStoreCoordinator()
            if coordinator != nil {
                self.managedObjectContext = NSManagedObjectContext()
                managedObjectContext.undoManager = nil
                managedObjectContext.persistentStoreCoordinator = coordinator
                // subscribe to change notifications
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "_mocDidSaveNotification:", name: NSManagedObjectContextDidSaveNotification, object: nil)
            }
            return managedObjectContext
        }
    }

    // Object model for CoreData
    var managedObjectModel: NSManagedObjectModel {
        get {
            if managedObjectModel != nil {
                return managedObjectModel
            }
            var modelURL: NSURL = NSBundle.mainBundle()(URLForResource: "Demo", withExtension: "momd")
            self.managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)
            return managedObjectModel
        }
    }

    // Persistent store coordinator for CoreData
    var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        get {
            if persistentStoreCoordinator != nil {
                return persistentStoreCoordinator
            }
            var storeURL: NSURL = self.applicationDocumentsDirectory().URLByAppendingPathComponent(kSqliteName)
                //add lightweight migration
            var options: [NSObject : AnyObject] = [
                    NSMigratePersistentStoresAutomaticallyOption : Int(true),
                    NSInferMappingModelAutomaticallyOption : Int(true)
                ]
    
            var error: NSError? = nil
            self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel())
            if !persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options, error: error!) {
                abort()
            }
            return persistentStoreCoordinator
        }
    }

    // Save context

    func saveContext() {
        var error: NSError? = nil
        var managedObjectContext: NSManagedObjectContext = self.managedObjectContext
        if managedObjectContext != nil {
            if managedObjectContext.hasChanges() && !managedObjectContext.save(error!) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                abort()
            }
        }
    }
    // Get singleton instance

    class func sharedInstance() -> CoreDataManager {
        var sharedInstance: AnyObject? = nil
            var onceToken: dispatch_once_t
        dispatch_once(onceToken, {() -> Void in
            sharedInstance = self()
        })
        return (sharedInstance as! CoreDataManager)
    }

    func intitializeAnEntityObjectByEntityName(name: String, withClass self: AnyClass, withIsForSaving forSaving: Bool) -> AnyObject {
        var entity: NSEntityDescription = NSEntityDescription.entityForName(name!, inManagedObjectContext: self.managedObjectContext)
            var object: AnyObject
        if forSaving {
            object = self(entity: entity, insertIntoManagedObjectContext: self.managedObjectContext)
        }
        else {
            object = self(entity: entity, insertIntoManagedObjectContext: nil)
        }
        return object
    }

    convenience override init() {
        super.init()
        if self != nil {
            self.managedObjectContext = self.managedObjectContext()
        }
    }

    func _mocDidSaveNotification(notification: NSNotification) {
        var savedContext: NSManagedObjectContext = notification.object
        // ignore change notifications for the main MOC
        if managedObjectContext == savedContext {
            return
        }
        if managedObjectContext.persistentStoreCoordinator != savedContext.persistentStoreCoordinator {
            // that's another database
            return
        }
        dispatch_sync(dispatch_get_main_queue(), {() -> Void in
            managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
        })
    }
    // Returns the managed object context for the application.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    // Returns the managed object model for the application.
    // If the model doesn't already exist, it is created from the application's model.
    // Returns the persistent store coordinator for the application.
    // If the coordinator doesn't already exist, it is created and the application's store added to it.

    func applicationDocumentsDirectory() -> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(NSCachesDirectory, inDomains: NSUserDomainMask).lastObject()
    }
}
//
//  CoreDataManager.m
//  NUS Technology
//
//  Created by NUS Technology on 6/20/14.
//
//

import CoreData
import CoreData
//
//  User+Helper.h
//  Sample Code
//
//  Created by NUS Technology on 1/13/15.
//  Copyright (c) 2015 Sample Code. All rights reserved.
//

extension User {
    convenience override init() {
        self = CoreDataManager.sharedInstance().intitializeAnEntityObjectByEntityName(User.entityName, withClass: User.self, withIsForSaving: false)
    }

    func copyDataFromObject(source: User) {
        self.email = source.email
        self.password = source.password
    }

    class func entityName() -> String {
        return "User"
    }

    class func fetchUser(recordId: String) -> User {
        var context: NSManagedObjectContext = CoreDataManager.sharedInstance().managedObjectContext()
        var fetchRequest: NSFetchRequest = NSFetchRequest()
        var entity: NSEntityDescription = NSEntityDescription.entityForName(User.managedObjectEntityName(), inManagedObjectContext: context)
        fetchRequest.entity = entity
        var predicate: NSPredicate = NSPredicate(format: "userId = %@", recordId)
        fetchRequest.predicate = predicate
        var error: NSError? = nil
        var fetchedObjects: [AnyObject] = context.executeFetchRequest(fetchRequest, error: error!)
        var returnedItem: User? = nil
        if fetchedObjects != nil {
            for obj: NSManagedObject in fetchedObjects {
                    //strong typecast
                var convertingError: NSError? = nil
                returnedItem = MTLManagedObjectAdapter.modelOfClass(User.self, fromManagedObject: obj, error: convertingError!)
            }
        }
        return returnedItem!
    }

    class func saveLocalItems(items: [AnyObject]) -> [AnyObject] {
        User.synchUsers(items)
        return User.parseUsers(items)
    }

    class func deleteUsers(users: [AnyObject]) -> [AnyObject] {
        var usersList: [AnyObject] = [AnyObject](minimumCapacity: 0)
        var context: NSManagedObjectContext = CoreDataManager.sharedInstance().managedObjectContext()
        for userRecord: User in users {
            var insertingError: NSError? = nil
            var user: NSManagedObject = MTLManagedObjectAdapter.managedObjectFromModel(userRecord, insertingIntoContext: context, error: insertingError!)
            if user != nil {
                context.deleteObject(user)
                var convertingError: NSError? = nil
                var modelUser: User = MTLManagedObjectAdapter.modelOfClass(User.self, fromManagedObject: user, error: convertingError!)
                if !convertingError {
                    usersList.append(modelUser)
                }
            }
        }
        var error: NSError? = nil
        if !context.save(error!) {

        }
        return usersList
    }

    class func synchUsers(users: [AnyObject]) -> Bool {
        var context: NSManagedObjectContext = CoreDataManager.sharedInstance().managedObjectContext()
        var fetchRequest: NSFetchRequest = NSFetchRequest()
        var entity: NSEntityDescription = NSEntityDescription.entityForName(User.managedObjectEntityName(), inManagedObjectContext: context)
        fetchRequest.entity = entity
            // get userid list
        var userIds: [AnyObject] = NSMutableArray()
        for user: User in users {
            userIds.append(user.identifier)
        }
        fetchRequest.predicate = NSPredicate(format: "NOT (userId IN %@)", userIds)
        // Make sure the results are sorted as well.
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "userId", ascending: true)]
        // Execute the fetch.
        NSError * error
        var deletedUsers: [AnyObject] = context.executeFetchRequest(fetchRequest, error: error!)
        for item: AnyObject in deletedUsers {
            context.deleteObject(item)
        }
        error = nil
        if !context.save(error!) {

        }
        return true
    }

    class func parseUsers(users: [AnyObject]) -> [AnyObject] {
        var context: NSManagedObjectContext = CoreDataManager.sharedInstance().managedObjectContext()
        var usersList: [AnyObject] = [AnyObject](minimumCapacity: 0)
        for userRecord: User in users {
            var insertingError: NSError? = nil
            var user: NSManagedObject = MTLManagedObjectAdapter.managedObjectFromModel(userRecord, insertingIntoContext: context, error: insertingError!)
            var convertingError: NSError? = nil
            var modelUser: User = MTLManagedObjectAdapter.modelOfClass(User.self, fromManagedObject: user, error: convertingError!)
            if !convertingError {
                usersList.append(modelUser)
            }
        }
        var error: NSError? = nil
        if !context.save(error!) {

        }
        return usersList
    }
}
//
//  User+Helper.m
//  Sample Code
//
//  Created by NUS Technology on 1/13/15.
//  Copyright (c) 2015 Dev. All rights reserved.
//
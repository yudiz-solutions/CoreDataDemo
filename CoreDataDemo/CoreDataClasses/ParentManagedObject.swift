//
//  ParentManagedObject.swift
//  Voila
//
//  Created by Yudiz Solutions Pvt. Ltd. on 03/10/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import CoreData


//func coreDataobject<T: NSManagedObject>(entityName: String, aId: String, key: String) -> T? {
//    let fetchRequest = NSFetchRequest()
//    let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: _appDelegator.managedObjectContext!)
//    fetchRequest.fetchLimit = 1
//    fetchRequest.entity = entity
//    fetchRequest.predicate = NSPredicate(format: "\(key) = '\(aId)'")
//    do {
//        let fetches = (try _appDelegator.managedObjectContext!.executeFetchRequest(fetchRequest)) as! [T]
//        if !fetches.isEmpty {
//            return fetches[0]
//        } else {
//            return nil
//        }
//    } catch let error as  NSError {
//        print("Error in fetching " + entityName + "Error detail: " + error.localizedDescription)
//        return nil
//    }
//}

//MARK: - NSManagedObject
extension NSManagedObject {
    class func entityName() -> String {
        return "\(self.classForCoder())"
    }
    
    class func deleteRemovedObject(oldObjs: [NSManagedObject], newObjs:[NSManagedObject]){
        var setOld = Set(oldObjs)
        let setNew = Set(newObjs)
        
        setOld.subtract(setNew)
        jprint(items: setOld)
        
        for obj in setOld{
            _appDelegator.managedObjectContext.delete(obj)
        }
        _appDelegator.saveContext()
    }
}

//MARK: - Protocol ParentManagedObject
protocol ParentManagedObject {
    
//    /***
//     It will insert new object record in database and return NSManagedObject
//     */
//    static func insertNewObject() -> NSManagedObject
//    
//    /***
//     It will update object record if exists otherwise insert new object record in database and return NSManagedObject
//     */
//    static func updateExistingObject(byKey: String, value: String) -> NSManagedObject
}

extension ParentManagedObject where Self: NSManagedObject {
    
    /***
     It will create a new entity in database by passing its name and return NSManagedObject
     */
    static func createNewEntity() -> Self {
        let object = NSEntityDescription.insertNewObject(forEntityName: Self.entityName(), into: _appDelegator.managedObjectContext) as! Self
        return object
    }
    
    
    static func addUpdateEntity(key: String,value:NSString) -> Self {
        let predicate = NSPredicate(format: "%K = %@",key,value)
        
        let results = fetchDataFromEntity(predicate: predicate, sortDescs: nil)
        let entity: Self
        
        if results.isEmpty{
            entity = createNewEntity()
        }else{
            entity = results.first!
        }
        return entity
    }

    
    /***
     It will return NSEntityDescription optional value, by passing entity name.
     */
    static func getExisting() -> NSEntityDescription? {
        let entityDesc = NSEntityDescription.entity(forEntityName: Self.entityName(), in: _appDelegator.managedObjectContext)
        return entityDesc
    }

    /***
     It will return an array of existing values from given entity name, with peredicate and sort description.
     */
    static func fetchDataFromEntity(predicate:NSPredicate?, sortDescs:NSArray?)-> [Self] {
        let entityDesc = getExisting()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDesc
        
        if let _ = predicate {
            fetchRequest.predicate = predicate
        }
        if let _ = sortDescs {
            fetchRequest.sortDescriptors = sortDescs as? Array
        }
        
        do {
            let resultsObj = try _appDelegator.managedObjectContext.fetch(fetchRequest)
            if (resultsObj as! [Self]).count > 0 {
                return resultsObj as! [Self]
            }else{
                return []
            }
            
        } catch let error as NSError {
            jprint(items: "Error in fetchedRequest : \(error.localizedDescription)")
            return []
        }
    }
}

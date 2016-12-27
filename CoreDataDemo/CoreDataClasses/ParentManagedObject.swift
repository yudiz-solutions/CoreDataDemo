//
//  ParentManagedObject.swift
//  Voila
//
//  Created by Yudiz Solutions Pvt. Ltd. on 03/10/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import CoreData


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
    
    
}

extension ParentManagedObject where Self: NSManagedObject {
    
    /***
     It will create a new entity in database by passing its name and return NSManagedObject
     */
    static func createNewEntity() -> Self {
        let object = NSEntityDescription.insertNewObject(forEntityName: Self.entityName(), into: _appDelegator.managedObjectContext) as! Self
        return object
    }
    
    /***
     It will create a new entity in database by passing its name and return NSManagedObject, if object with that primary key already exist it will fetch that object and return.
     */
    static func createNewEntity(key: String,value:NSString) -> Self {
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
     It will check for entity with that primary key  if found object will get return or will return nil.
     */
    static func checkEntity(key: String,value:NSString) -> Self? {
        let predicate = NSPredicate(format: "%K = %@",key,value)
        
        let results = fetchDataFromEntity(predicate: predicate, sortDescs: nil)
        
        if results.isEmpty{
            return nil
        }else{
            return results.first
        }
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

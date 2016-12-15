//
//  User.swift
//  CoreDataDemo
//
//  Created by Yudiz on 12/15/16.
//  Copyright © 2016 Yudiz. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject, ParentManagedObject {
    @NSManaged var id : Int32
    @NSManaged var name : String
    
    func initWith(data: NSDictionary){
        id = data.getInt32Value(key: "id")
        name = data["name"] as! String
    }
}

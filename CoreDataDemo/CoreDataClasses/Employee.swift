//
//  Employee.swift
//  CoreDataDemo
//
//  Created by Yudiz on 12/15/16.
//  Copyright © 2016 Yudiz. All rights reserved.
//

import Foundation
import CoreData

class Employee: NSManagedObject, KPParentManagedObject {
    @NSManaged var name : String
}

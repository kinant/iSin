//
//  Sin.swift
//  iSin
//
//  Created by Kinan Turman on 4/3/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import CoreData

class Sin: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var type: NSNumber
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(name: String, type: Int, entityName:String, context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.name = name
        self.type = type
    }
}
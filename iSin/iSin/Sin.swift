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
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(name: String, context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entityForName("Sin", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.name = name
    }
}
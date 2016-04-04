//
//  SinRecord.swift
//  iSin
//
//  Created by Kinan Turman on 4/4/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation
import CoreData

class SinRecord: NSManagedObject {

    @NSManaged var date_added: NSDate
    @NSManaged var sin: Sin
    @NSManaged var passages: NSSet?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("SinRecord", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.date_added = NSDate()
    }
    
    var dateString: String {
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.stringFromDate(self.date_added)
    }
}

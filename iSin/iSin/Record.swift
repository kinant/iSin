//
//  SinRecord.swift
//  iSin
//
//  Created by Kinan Turman on 4/4/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation
import CoreData

/* This class (and entity) is used by CoreData and APP to store the user's records of sins commited and
    any passages that he selects for this record.
 */
class Record: NSManagedObject {

    // properties
    @NSManaged var date_added: NSDate
    @NSManaged var sin: RecordSin //the user will record ONE sin
    @NSManaged var passages: NSSet? //the user can choose to save an array of passages
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Record", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // set to today's date
        self.date_added = NSDate()
    }
    
    // used get the record's date as a string
    var dateString: String {
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.stringFromDate(self.date_added)
    }
}

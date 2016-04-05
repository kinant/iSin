//
//  RecordSin.swift
//  iSin
//
//  Created by Kinan Turman on 4/4/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import CoreData

/* This class (and entity) is used by CoreData and APP to store the sins in a record 
    Must be a seperate entity so that we can add Sin's to as many records as we want.
    CoreData will not work well otherwise. The other sin entity is used just to list
    the sins that the user can use.
 */
class RecordSin: Sin {
    @NSManaged var record: Record?
}
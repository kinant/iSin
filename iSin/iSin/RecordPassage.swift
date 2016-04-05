//
//  RecordPassage.swift
//  iSin
//
//  Created by Kinan Turman on 4/4/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import CoreData

/* This class (and entity) is used by CoreData and APP to store the passages in a record
    Must be a seperate entity so that we can add passages to as many records as we want.
    CoreData will not work well otherwise. The other passage entity is used just to list
    the passages that the user can use.
 */
class RecordPassage: Passage {
    @NSManaged var record: Record?
}
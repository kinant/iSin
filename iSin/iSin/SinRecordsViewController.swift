//
//  SinRecordsViewController.swift
//  iSin
//
//  Created by Kinan Turman on 4/4/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import UIKit
import CoreData

class SinRecordsViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var records = [SinRecord]()
    
    override func viewDidLoad() {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
        self.records = fetchAllRecords()
        
        for i in 0 ..< records.count {
            print("Record \(i) added ", records[i].dateString, " with sin: ", records[i].sin.name)
        }
    }
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    func fetchAllRecords() -> [SinRecord] {
        
        let fetchRequest = NSFetchRequest(entityName: "SinRecord")
        
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [SinRecord]
        } catch let error as NSError {
            return [SinRecord]()
        }
    }

    
}

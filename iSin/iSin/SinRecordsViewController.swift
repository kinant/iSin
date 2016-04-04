//
//  SinRecordsViewController.swift
//  iSin
//
//  Created by Kinan Turman on 4/4/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import UIKit
import CoreData

class SinRecordsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var records = [SinRecord]()
    var sinNames = ["LUST", "GLUTTONY", "GREED", "SLOTH", "WRATH", "ENVY", "PRIDE"]
    
    override func viewDidLoad() {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SinRecordCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.records = fetchAllRecords()
        
        tableView.reloadData()
        
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SinRecordCell")
        
        let record = records[indexPath.row]
        
        cell?.textLabel?.text = "\(sinNames[record.sin.type.integerValue]): \(record.dateString), # passages = \(record.passages.count)"
        return cell!
        
    }

    
}

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
    
    var records = [Record]()
    var sinNames = ["LUST", "GLUTTONY", "GREED", "SLOTH", "WRATH", "ENVY", "PRIDE"]
    
    var selectedRecord: Record!
    
    override func viewDidLoad() {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
        self.tableView.registerNib(UINib(nibName: "CustomRecordCellView", bundle: nil), forCellReuseIdentifier: "RecordCell")
        
        //self.tableView.registerClass(CustomRecordCellView.self, forCellReuseIdentifier: "RecordCell")
        
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
    
    func fetchAllRecords() -> [Record] {
        
        let fetchRequest = NSFetchRequest(entityName: "Record")
        
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Record]
        } catch let error as NSError {
            return [Record]()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RecordCell") as! CustomRecordCellView
        
        let record = records[indexPath.row]
        
        cell.typeLabel.text = "\(sinNames[record.sin.type.integerValue - 1])"
        cell.dateLabel.text = record.dateString
        cell.passageLabel.text = "#:\(record.passages!.count)"
        
        //cell?.textLabel?.text = "\(sinNames[record.sin.type.integerValue - 1]): \(record.dateString), # passages = \(record.passages!.count)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRecord = records[indexPath.row]
        performSegueWithIdentifier("ShowRecordDetail", sender: self)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            switch (editingStyle) {
            case .Delete:
                let record = records[indexPath.row]
                
                records.removeAtIndex(indexPath.row)
                
                // Remove the row from the table
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                
                // Remove the movie from the context
                sharedContext.deleteObject(record)
                CoreDataStackManager.sharedInstance().saveContext()
            default:
                break
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowRecordDetail" {
            let recordDetailVC = segue.destinationViewController as! RecordDetailViewController
            recordDetailVC.record = selectedRecord
        }
    }
}

//
//  SinRecordsViewController.swift
//  iSin
//
//  Created by Kinan Turman on 4/4/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import UIKit
import CoreData

/* Class for the add sin records view controller */
class SinRecordsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlet variables
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties and variables
    var records = [Record]()
    var sinNames = ["LUST", "GLUTTONY", "GREED", "SLOTH", "WRATH", "ENVY", "PRIDE"]
    
    // store the record that the user selects
    var selectedRecord: Record!
    
    // MARK: View functions
    override func viewDidLoad() {
        
        // for toggling the menu (SWRevealViewController)
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
        // register the nib so we can use custom cell view
        self.tableView.registerNib(UINib(nibName: "CustomRecordCellView", bundle: nil), forCellReuseIdentifier: "RecordCell")
        
        // set tableview delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // fetch all records
        self.records = fetchAllRecords()
        
        // reload data
        tableView.reloadData()
    }
    
    // override prepareForSegue to set variables for the Record Detail View Controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // check the identifier
        if segue.identifier == "ShowRecordDetail" {
            
            // set the variables
            let recordDetailVC = segue.destinationViewController as! RecordDetailViewController
            recordDetailVC.record = selectedRecord
        }
    }
    
    /* function for the number of rows */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    /* function for the creation of each cell in the tableview */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // deque and get the cell
        let cell = tableView.dequeueReusableCellWithIdentifier("RecordCell") as! CustomRecordCellView
        
        // set the record
        let record = records[indexPath.row]
        
        // set the labels
        cell.typeLabel.text = "\(sinNames[record.sin.type.integerValue - 1])"
        cell.dateLabel.text = record.dateString
        cell.passageLabel.text = "#:\(record.passages!.count)"
        
        return cell
        
    }
    
    /* function to handle the selection of a tableview row */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRecord = records[indexPath.row]
        performSegueWithIdentifier("ShowRecordDetail", sender: self)
    }
    
    /* function for adding the ability to delete a row when swipping it and pressing delete */
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            switch (editingStyle) {
            case .Delete:
                
                // get the record
                let record = records[indexPath.row]
                
                // remove it from the array
                records.removeAtIndex(indexPath.row)
                
                // Remove the row from the table
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                
                // Remove the record from the context
                sharedContext.deleteObject(record)
                
                // save the context
                CoreDataStackManager.sharedInstance().saveContext()
            default:
                break
            }
        }
    }

    // MARK: CoreData functions and variables
    
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
}

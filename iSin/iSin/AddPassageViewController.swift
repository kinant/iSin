//
//  AddPassageViewController.swift
//  iSin
//
//  Created by Kinan Turman on 4/2/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation
import CoreData

class AddPassageViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sinID:Int!
    var passages = [Passage]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PassageCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        if self.navigationController != nil {
            print("does have navigation controller!")
            self.title = "Select Passages"
            
            let newRightButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddPassageViewController.cancelButtonPressed))
             navigationItem.setRightBarButtonItem(newRightButton, animated: false)
        }
        
        self.passages = fetchAllPassages()
        
        if(passages.count == 0) {
            downloadData()
        }
    }
    
    func downloadData(){
        ISINClient.sharedInstance().getPassagesForSin(self.sinID) { (results, errorString) in
            
            if((errorString == nil)){
                for i in 0 ..< results.count {
                    let tempISINPassage = Passage(dictionary: nil, dataArray: results[i], sinID: self.sinID, context: self.scratchContext)
                    
                    ISINClient.sharedInstance().getPassage(tempISINPassage.title, completionHandlerForGetPassage: { (results, errorString) in
                        let bibleorgPassage = Passage(dictionary: results, dataArray: nil, sinID: self.sinID, context: self.sharedContext)
                        print(bibleorgPassage.text)
                        self.passages.append(bibleorgPassage)
                        
                        dispatch_async(dispatch_get_main_queue()){
                            print("will update table... ", self.passages.count)
                            self.tableView.reloadData()
                        }
                        
                        self.saveContext()
                    })
                }
            }
        }
    }
    
    func fetchAllPassages() -> [Passage] {
        
        let fetchRequest = NSFetchRequest(entityName: "Passage")
        
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "sin_type == \(sinID)");
        
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Passage]
        } catch let error as NSError {
            print("Error in fetchAllActors(): \(error)")
            return [Passage]()
        }
    }

    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    lazy var scratchContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext()
        context.persistentStoreCoordinator =  CoreDataStackManager.sharedInstance().persistentStoreCoordinator
        return context
    }()
    
    func cancelButtonPressed(){
        print("cancel button pressed!!")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("did select row...");
        showPassageTextAlert(indexPath.row)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PassageCell")
        
        cell?.textLabel?.text = passages[indexPath.row].title
        
        return cell!
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            switch (editingStyle) {
            case .Delete:
                let passage = passages[indexPath.row]
                
                passages.removeAtIndex(indexPath.row)
                // Remove the row from the table
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                
                // Remove the movie from the context
                sharedContext.deleteObject(passage)
                CoreDataStackManager.sharedInstance().saveContext()
            default:
                break
            }
        }
    }
    
    func showPassageTextAlert(passageIndex: Int){
        let refreshAlert = UIAlertController(title: passages[passageIndex].title, message: passages[passageIndex].text, preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            //refreshAlert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    func addCustomPassageConfirmAlert(searchTerm: String, sendingAlert: UIAlertController){
        
        print("ONE!")
        
        sendingAlert.view.removeFromSuperview()
        sendingAlert.removeFromParentViewController()
        sendingAlert.dismissViewControllerAnimated(false, completion: nil)
        print("TWO!")
        
        ISINClient.sharedInstance().getPassage(searchTerm, completionHandlerForGetPassage: { (results, errorString) in
            
            print("THREE!")
            
            let bibleorgPassage = Passage(dictionary: results, dataArray: nil, sinID: self.sinID, context: self.sharedContext)
            
            let message = "Is this your passage: " + bibleorgPassage.title + "?"
            
            let alert = UIAlertController(title: "Confirm Passage", message: message , preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "YES", style: .Default, handler: { (action) -> Void in
                self.passages.append(bibleorgPassage)
                
                dispatch_async(dispatch_get_main_queue()){
                    print("will update table... ", self.passages.count)
                    self.tableView.reloadData()
                }
                
                self.saveContext()
            }))
            
            alert.addAction(UIAlertAction(title: "NO", style: .Default, handler: { (action) -> Void in
                
            }))
            
            dispatch_async(dispatch_get_main_queue(), {
                self.presentViewController(alert, animated: true, completion: nil)
            })
        })
    }
    
    @IBAction func addCustomPassageButtonPressed(sender: UIButton) {
    
        let alert = UIAlertController(title: "Add Custom Passage", message: "Enter passage with format Book Chapter:Verse Start-VerseEnd", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })
        
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            
            if(textField.text! != ""){
                self.addCustomPassageConfirmAlert(textField.text!, sendingAlert: alert)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
            
        }))
        
        print("A!")
        alert.view.setNeedsLayout()
        print("B!")
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
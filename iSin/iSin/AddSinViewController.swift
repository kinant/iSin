//
//  AddSinViewController.swift
//  iSin
//
//  Created by Kinan Turman on 3/22/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation
import CoreData

class AddSinViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {

    var sinID:Int!
    var sins = [Sin]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SinCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        sins = fetchAllSins()
        
        if(sins.count == 0) {
            downloadData()
        }
    }
    
    func downloadData(){
        ISINClient.sharedInstance().getSinsCommitedForSinType(self.sinID) { (results, errorString) in
            // do smething...
            
            for i in 0 ..< results.count {
                let newSin = Sin(name: results[i], type: self.sinID, context: self.sharedContext)
                self.sins.append(newSin)
                
                self.saveContext()
            }
            
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
            }
        }
    }
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    func fetchAllSins() -> [Sin] {
        
        let fetchRequest = NSFetchRequest(entityName: "Sin")
        
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "type == \(sinID)");
        
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Sin]
        } catch let error as NSError {
            print("Error in fetchAllActors(): \(error)")
            return [Sin]()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("did select row...")
        // let passageSelectVC = storyboard?.instantiateViewControllerWithIdentifier("AddPassage") as! AddPassageViewController
        // passageSelectVC.sinID = self.sinID
        
        // presentViewController(passageSelectVC, animated: true, completion: nil)
        performSegueWithIdentifier("AddPassage", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sins.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SinCell")
        cell?.textLabel?.text = sins[indexPath.row].name
        return cell!
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
        
            switch (editingStyle) {
            case .Delete:
                let sin = sins[indexPath.row]
                
                sins.removeAtIndex(indexPath.row)
                // Remove the row from the table
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                
                // Remove the movie from the context
                sharedContext.deleteObject(sin)
                CoreDataStackManager.sharedInstance().saveContext()
            default:
                break
            }
        }
    }
    
    @IBAction func cancelPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func showAddOtherSinAlert(sender: UIButton){
        let alert = UIAlertController(title: "Add Custom Sin", message: "Enter a your sin", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })
        
        alert.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            
            if(textField.text! != ""){
                
                let newSin = Sin(name: textField.text!, type: self.sinID, context: self.sharedContext)
                self.sins.append(newSin)
                
                self.saveContext()
                //self.sins.append(textField.text!)
                
                dispatch_async(dispatch_get_main_queue()){
                    self.tableView.reloadData()
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in

        }))
        
        alert.view.setNeedsLayout()
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddPassage" {
            let addPassageVC = segue.destinationViewController as! AddPassageViewController
            addPassageVC.sinID = self.sinID
        }
    }
    
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
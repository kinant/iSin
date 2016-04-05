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
    var selectedSin: Sin!
    
    var apiSins = [Sin]()
    var customSins = [Sin]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SinCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        sins = fetchAllSins()
        
        if(sins.count == 0) {
            downloadData()
        }
        
        populateSinArrays()
        tableView.reloadData()
    }
    
    func populateSinArrays(){
        apiSins.removeAll()
        customSins.removeAll()
        
        for i in 0 ..< sins.count {
            if sins[i].isCustom {
                self.customSins.append(sins[i])
            } else {
                self.apiSins.append(sins[i])
            }
        }
    }
    
    func downloadData(){
        
        SwiftSpinner.show("Downloading...", description: "Downloading data from API", animated: true)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        ISINClient.sharedInstance().getSinsCommitedForSinType(self.sinID) { (results, errorString) in
            
            dispatch_async(dispatch_get_main_queue()){
                SwiftSpinner.hide()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            
            if(errorString == nil){
        
                for i in 0 ..< results!.count {
                    let newSin = Sin(name: results![i], type: self.sinID, entityName: ISINClient.EntityNames.ListSin, context: self.sharedContext)
                    self.sins.append(newSin)
                
                    self.saveContext()
                }
            
                dispatch_async(dispatch_get_main_queue()){
                    self.populateSinArrays()
                    self.tableView.reloadData()
                }
            } else {
                ISINClient.sharedInstance().showAlert(self, title: "ERROR", message: errorString!, actions: ["OK"], completionHandler: nil)
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //return 1
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        //return nil
        
        if section == 0 {
            return "API Sins"
        } else {
            return "Custom Sins"
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedSin = sins[indexPath.row]
        performSegueWithIdentifier("AddPassage", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return apiSins.count
        } else {
            return customSins.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SinCell")
        
        if indexPath.section == 0 {
            cell?.textLabel?.text = apiSins[indexPath.row].name
        } else {
            cell?.textLabel?.text = customSins[indexPath.row].name
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
        
            let sin:Sin!
            
            switch (editingStyle) {
            case .Delete:
                if(indexPath.section == 0) {
                    sin = apiSins[indexPath.row]
                    apiSins.removeAtIndex(indexPath.row)
                } else {
                    sin = customSins[indexPath.row]
                    customSins.removeAtIndex(indexPath.row)
                }
            
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
                
                let newSin = Sin(name: textField.text!, type: self.sinID, entityName: ISINClient.EntityNames.ListSin, context: self.sharedContext)
                newSin.isCustom = true
                
                self.sins.append(newSin)
                
                self.saveContext()
                
                dispatch_async(dispatch_get_main_queue()){
                    self.populateSinArrays()
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
            addPassageVC.sin = self.selectedSin
        }
    }
    
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getIndexOfAPISin(sin: Sin) -> Int? {
        for i in 0 ..< apiSins.count {
            if sin.name == apiSins[i].name {
                return i
            }
        }
        return nil
    }
    
    
    @IBAction func refreshPressed(sender: UIBarButtonItem) {
        // refresh pressed...
        apiSins.removeAll()
        
        for i in 0 ..< sins.count {
            if !sins[i].isCustom {
                
                if let delIndex = getIndexOfAPISin(sins[i]){
                    let indexPath = NSIndexPath(forRow: delIndex, inSection: 0)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
                
                sharedContext.deleteObject(sins[i])
            }
        }
        
        tableView.reloadData()
        
        sins = fetchAllSins()
        
        downloadData()
    }
    
}
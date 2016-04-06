//
//  AddSinViewController.swift
//  iSin
//
//  Created by Kinan Turman on 3/22/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation
import CoreData

/* Class for the add sin view controller */
class AddSinViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Outlet variables
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties and variables
    var sinID:Int!
    var sins = [Sin]()
    var selectedSin: Sin!
    
    // arrays to divide sins by their origin
    var apiSins = [Sin]()
    var customSins = [Sin]()
    
    // MARK: View functions
    override func viewDidLoad() {
        
        // set the nav bar buttons
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddSinViewController.cancelPressed))
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: #selector(AddPassageViewController.refreshPressed))
        
        navigationItem.setRightBarButtonItems([cancelButton, refreshButton], animated: false)
        
        // register the class so we can use custom cell view
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SinCell")
        
        // set tableview delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // fetch all sins
        sins = fetchAllSins()
        
        // if no sin fetched, download data
        if(sins.count == 0) {
            downloadData()
        }
        
        // populate relevant arrays and reload data
        populateSinArrays()
        tableView.reloadData()
    }
    
    // override prepareForSegue to set variables for the Add Passage View Controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // check the identifier
        if segue.identifier == "AddPassage" {
            
            // set the variables
            let addPassageVC = segue.destinationViewController as! AddPassageViewController
            addPassageVC.sinID = self.sinID
            addPassageVC.sin = self.selectedSin
        }
    }
    
    // MARK: TableView Functions
    
    /* function for the number of sections */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // we have two sections, one for API sins and one for custom sins
        return 2
    }
    
    /* function for the number of rows in each section */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return apiSins.count
        } else {
            return customSins.count
        }
    }
    
    /* function for the section headers */
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "API Sins"
        } else {
            return "Custom Sins"
        }
    }
    
    /* function for the header height */
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    /* function for the row height */
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    /* function for the creation of each cell in the tableview */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // deque and get the cell
        let cell = tableView.dequeueReusableCellWithIdentifier("SinCell")
        
        // set cell text color
        cell?.textLabel?.textColor = UIColor.whiteColor()
        cell?.textLabel?.lineBreakMode = .ByWordWrapping
        cell?.textLabel?.numberOfLines = 2
        cell?.textLabel?.sizeToFit()
        
        // check the section and assing the text
        if indexPath.section == 0 {
            cell?.textLabel?.text = apiSins[indexPath.row].name
        } else {
            cell?.textLabel?.text = customSins[indexPath.row].name
        }
        
        return cell!
    }
    
    /* function to handle the selection of a tableview row */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // set the selected sin, perform segue so that the add passage screen is shown
        selectedSin = sins[indexPath.row]
        performSegueWithIdentifier("AddPassage", sender: self)
    }
    
    /* function for adding the ability to delete a row when swipping it and pressing delete */
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            // define a sin that we will initialize later
            let sin:Sin!
            
            // check what the editing style is
            switch (editingStyle) {
            // we only worry about delete
            case .Delete:
                
                // check the section and assing the sin based on the section and the array it applies to
                if(indexPath.section == 0) {
                    sin = apiSins[indexPath.row]
                    apiSins.removeAtIndex(indexPath.row)
                } else {
                    sin = customSins[indexPath.row]
                    customSins.removeAtIndex(indexPath.row)
                }
                
                // Remove the row from the table
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                
                // Remove the sin from the context
                sharedContext.deleteObject(sin)
                
                // Save the context
                CoreDataStackManager.sharedInstance().saveContext()
            default:
                break
            }
        }
    }
    
    // MARK: CoreData functions and variables
    func saveContext() {
        dispatch_async(dispatch_get_main_queue()){
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    // fetches all saved sins
    func fetchAllSins() -> [Sin] {
        
        let fetchRequest = NSFetchRequest(entityName: "Sin")
        
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "type == \(sinID)");
        
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Sin]
        } catch let error as NSError {
            return [Sin]()
        }
    }
    
    // MARK: Other Functions
    
    // this function populates the custom and api sin arrays based on their origin
    func populateSinArrays(){
        
        // clear both arrays
        apiSins.removeAll()
        customSins.removeAll()
        
        // iterate over all the sins, and assign it to its proper array
        for i in 0 ..< sins.count {
            if sins[i].isCustom {
                self.customSins.append(sins[i])
            } else {
                self.apiSins.append(sins[i])
            }
        }
    }
    
    /* function to download API data */
    func downloadData(){
        
        // start the spinner and network indicator
        SwiftSpinner.show("Downloading...", description: "Downloading data from API", animated: true)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        // get the data for the sins commited (a list of sins)
        ISINClient.sharedInstance().getSinsCommitedForSinType(self.sinID) { (results, errorString) in
            
            // check for errors
            if(errorString == nil){
        
                // iterate over each sin in the results
                for i in 0 ..< results!.count {
                    
                    // create the sin
                    let newSin = Sin(name: results![i], type: self.sinID, entityName: ISINClient.EntityNames.ListSin, context: self.sharedContext)
                    
                    // append it to the array
                    self.sins.append(newSin)
                
                    // save the context
                    self.saveContext()
                }
            
                // populate the separate arrays and reload the table
                dispatch_async(dispatch_get_main_queue()){
                    self.populateSinArrays()
                    self.tableView.reloadData()
                }
            } else {
                // there was an error, show the alert
                ISINClient.sharedInstance().showAlert(self, title: "ERROR", message: errorString!, actions: ["OK"], completionHandler: nil)
                
                
            }
            
            // once done, hide the indicator and the spinner
            dispatch_async(dispatch_get_main_queue()){
                SwiftSpinner.hide()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        }
    }
    
    /* helper function to get the index of an api sin */
    func getIndexOfAPISin(sin: Sin) -> Int? {
        
        // iterate over all the api sins
        for i in 0 ..< apiSins.count {
            
            // check if it is the sin we are looking for
            if sin.name == apiSins[i].name {
                
                // if so, return the index
                return i
            }
        }
        
        // no match, return nil
        return nil
    }
    
    // handle the press of the add custom sin button
    // app alows the user to add their own sin
    @IBAction func showAddOtherSinAlert(sender: UIButton){
        
        // create an alert so that the user can type-in their custom sin
        let alert = UIAlertController(title: "Add Custom Sin", message: "Enter your sin:", preferredStyle: .Alert)
        
        // add textfield to alert
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })
        
        // add the action to add the custom sin
        alert.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (action) -> Void in
            
            // get data from textfield
            let textField = alert.textFields![0] as UITextField
            
            if(textField.text! != ""){
                
                // create a new sin from custom sin
                let newSin = Sin(name: textField.text!, type: self.sinID, entityName: ISINClient.EntityNames.ListSin, context: self.sharedContext)
                
                // set the flag
                newSin.isCustom = true
                
                // append to array
                self.sins.append(newSin)
                
                // save the context
                self.saveContext()
                
                // populate the relevant arrays and reload the table
                dispatch_async(dispatch_get_main_queue()){
                    self.populateSinArrays()
                    self.tableView.reloadData()
                }
            }
        }))
        
        // add the action
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in

        }))
        
        // call this function to avoid a serious error/bug due to layout of alert
        // alert will not show otherwise
        alert.view.setNeedsLayout()
        
        // present the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /* handle the press of the cancel button */
    func cancelPressed() {
        // dismiss the view
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /* handle the press of the refresh button
        user wants to refresh the api data
     */
    func refreshPressed() {
        
        // remove all the api sins
        apiSins.removeAll()
        
        // iterate over all the sins
        for i in 0 ..< sins.count {
            
            // check that the sin is an api sin (not custom)
            if !sins[i].isCustom {
                
                // get the index of the sin
                if let delIndex = getIndexOfAPISin(sins[i]){
                    
                    // create the indexpath
                    let indexPath = NSIndexPath(forRow: delIndex, inSection: 0)
                    
                    // delete the row from the table view
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
                
                // remove the sin from the context
                sharedContext.deleteObject(sins[i])
            }
        }
        
        // reload the table
        tableView.reloadData()
        
        // reset the sins array (this will populate it with only the remaining sins, which are all the
        // custom ones
        sins = fetchAllSins()
        
        // proceed to download the data again (from API)
        downloadData()
    }
}
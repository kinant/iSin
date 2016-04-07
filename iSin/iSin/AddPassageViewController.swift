//
//  AddPassageViewController.swift
//  iSin
//
//  Created by Kinan Turman on 4/2/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation
import CoreData

/* Class for the add passages view controller */
class AddPassageViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    // MARK: Outlet variables
    @IBOutlet weak var tableView: UITableView!
    
    var sinID:Int!
    var passages = [Passage]()
    var sin: Sin!
    var selectedIndexes = [NSIndexPath]()
    
    // arrays to divide the passages by their origin
    var apiPassages = [Passage]()
    var customPassages = [Passage]()
    
    // MARK: View functions
    override func viewDidLoad() {
        
        // register the nib so we can use the custom cell view
        self.tableView.registerNib(UINib(nibName: "CustomPassageCellView", bundle: nil), forCellReuseIdentifier: "PassageCell")
        
        // set table delegate and source
        tableView.delegate = self
        tableView.dataSource = self
        
        // allow user to select more than one row
        tableView.allowsMultipleSelection = true
        
        // customize the nav bar
        if self.navigationController != nil {
            self.title = "Select Passages"
            
            // set nav bar buttons
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddPassageViewController.cancelPressed))
            
            let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: #selector(AddPassageViewController.refreshPressed))

            navigationItem.setRightBarButtonItems([cancelButton, refreshButton], animated: false)
        }
        
        // fetch all the passages
        self.passages = fetchAllPassages()
        
        // if no passage fetched, download the data
        if(passages.count == 0) {
            downloadData()
        }
        
        // populate the relevant arrays and reload table
        populatePassageArrays()
        tableView.reloadData()
        
    }
    
    // MARK: TableView Functions
    
    /* function for the number of sections */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    /* function for the section headers */
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "API Passages"
        } else {
            return "Custom Passages"
        }
    }
    
    /* function for the number of rows in each section */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return apiPassages.count
        } else {
            return customPassages.count
        }
    }
    
    /* function for the creation of each cell in the tableview */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // deque and get the cell
        let cell = tableView.dequeueReusableCellWithIdentifier("PassageCell") as! CustomPassageCellView
        
        // check what section the cell belongs to
        if indexPath.section == 0 {
            // api cell, set labels
            cell.titleLabel.text = apiPassages[indexPath.row].title
            cell.passageTitle = apiPassages[indexPath.row].title
            cell.passageText = apiPassages[indexPath.row].text
        } else {
            // custom cell, set labels
            cell.titleLabel.text = customPassages[indexPath.row].title
            cell.passageTitle = customPassages[indexPath.row].title
            cell.passageText = customPassages[indexPath.row].text
        }
        
        return cell
    }
    
    /* function for the selection of a row */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // append the indexPath to the selected indexes array
        selectedIndexes.append(indexPath)
    }
    
    /* function for the de-selection of a row */
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        // find the indexPath in the array
        if let index = selectedIndexes.indexOf(indexPath) {
            // remove it from the array
            selectedIndexes.removeAtIndex(index)
        }
    }
    
    /* function for adding the ability to delete a row when swipping it and pressing delete */
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            let passage:Passage!
            
            switch (editingStyle) {
            case .Delete:
                if(indexPath.section == 0) {
                    passage = apiPassages[indexPath.row]
                    apiPassages.removeAtIndex(indexPath.row)
                } else {
                    passage = customPassages[indexPath.row]
                    customPassages.removeAtIndex(indexPath.row)
                }
                
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
    
    // MARK: CoreData functions and variables
    
    func saveContext() {
        dispatch_async(dispatch_get_main_queue()){
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    // dummy context
    lazy var scratchContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext()
        context.persistentStoreCoordinator =  CoreDataStackManager.sharedInstance().persistentStoreCoordinator
        return context
    }()
    
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
    
    // MARK: Other Functions
    
    /* function to download API data */
    func downloadData(){
        
        // start the spinner and network indicator
        SwiftSpinner.show("Downloading...", description: "Downloading data from API", animated: true)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        // get the data for the sin passages (a list of passage titles)
        // this is the data from the iSin API
        ISINClient.sharedInstance().getPassagesForSin(self.sinID) { (results, errorString) in
            
            // check that there were no errors
            if((errorString == nil)){
                
                // get the total count of results
                let totalCount = results!.count - 1
                
                // a counter to count how many passages have been downloaded
                var currentCount = 0
                
                // iterate over each passage title downloaded
                for i in 0 ..< results!.count {
                    
                    // create a temporary passage
                    let tempISINPassage = Passage(dictionary: nil, dataArray: results![i], sinID: self.sinID, entityName: ISINClient.EntityNames.ListPassage, context: self.scratchContext)
                    
                    // download the passage data
                    ISINClient.sharedInstance().getPassage(tempISINPassage.title, completionHandlerForGetPassage: { (results, errorString) in
                        
                        // increment the count
                        currentCount += 1
                        
                        dispatch_async(dispatch_get_main_queue()){
                            // create the FULL passage (with text)
                            let bibleorgPassage = Passage(dictionary: results, dataArray: nil, sinID: self.sinID, entityName: ISINClient.EntityNames.ListPassage, context: self.sharedContext)
                        
                            // added to the passages array
                            self.passages.append(bibleorgPassage)
                        }
                        
                        // check if all the passages have been downloaded (by the counter)
                        if(currentCount == totalCount){
                            dispatch_async(dispatch_get_main_queue()){
                                
                                // populate the relevant arrays
                                self.populatePassageArrays()
                                
                                // empty the selected indexes (fixes a bug)
                                self.selectedIndexes.removeAll()

                                // reload table
                                self.tableView.reloadData()
                                
                                // hide spinner and network indicator
                                SwiftSpinner.hide()
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                
                            }
                        }
                        
                        // save the context with each downloaded record
                        self.saveContext()
                    })
                }
            } else {
                // hide spinner and network indicator
                dispatch_async(dispatch_get_main_queue()){
                    SwiftSpinner.hide()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
                // there was an error, show alert
                ISINClient.sharedInstance().showAlert(self, title: "ERROR", message: errorString!, actions: ["OK"], completionHandler: nil)
            }
        }
    }
    
    // this function populates the custom and api passage arrays based on their origin
    func populatePassageArrays(){
        
        // clear both arrays
        apiPassages.removeAll()
        customPassages.removeAll()

        // iterate over all the passages, and assign it to its proper array
        for i in 0 ..< passages.count {
            if passages[i].isCustom {
                self.customPassages.append(passages[i])
            } else {
                self.apiPassages.append(passages[i])
            }
        }
    }
    
    /* helper function to get the index of an api passage */
    func getIndexOfAPIPassage(passage: Passage) -> Int? {
        for i in 0 ..< apiPassages.count {
            if passage.title == apiPassages[i].title {
                return i
            }
        }
        return nil
    }
    
    /* handle the press of the cancel button */
    func cancelPressed(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /* handle the press of the refresh button */
    func refreshPressed() {
        
        // clear api passages array
        apiPassages.removeAll()
        
        // iterate over all the passages
        for i in 0 ..< passages.count {
            
            // check that the passage is an api passage (not custom)
            if !passages[i].isCustom {
                
                // get the index of the sin
                if let delIndex = getIndexOfAPIPassage(passages[i]){
                    
                    // create the indexpath
                    let indexPath = NSIndexPath(forRow: delIndex, inSection: 0)
                    
                    // delete the row from the table view
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
                
                // remove the passage from the context
                sharedContext.deleteObject(passages[i])
            }
        }
        
        // reload the table
        tableView.reloadData()
        
        // reset the sins array (this will populate it with only the remaining sins, which are all the
        // custom ones
        passages = fetchAllPassages()
        
        // proceed to download the data again (from API)
        downloadData()
    }
    
    /* function that shows an alert so that the user can confirm
        if the passage that he inserted (for custom passage) is found
        and that it is the passage they want
     */
    func addCustomPassageConfirmAlert(searchTerm: String, sendingAlert: UIAlertController){
        
        // remove the sending alert (the one with the textfield that the user fills)
        sendingAlert.view.removeFromSuperview()
        sendingAlert.removeFromParentViewController()
        sendingAlert.dismissViewControllerAnimated(false, completion: nil)
        
        // start the spinner and network indicator
        SwiftSpinner.show("Downloading...", description: "Downloading data from API", animated: true)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        // download passage from bible org
        ISINClient.sharedInstance().getPassage(searchTerm, completionHandlerForGetPassage: { (results, errorString) in
            
            // check that there were no errors
            if(errorString == nil){
                
                // create a temporary passage
                let tempBibleorgPassage = Passage(dictionary: results, dataArray: nil, sinID: self.sinID, entityName: ISINClient.EntityNames.ListPassage, context: self.scratchContext)
                
                // ask the user to confirm the passage...
                let message = "Is this your passage: " + tempBibleorgPassage.title + "?"
                
                let alert = UIAlertController(title: "Confirm Passage", message: message , preferredStyle: .Alert)
                
                // add action for yes
                alert.addAction(UIAlertAction(title: "YES", style: .Default, handler: { (action) -> Void in
                    
                    // this is the passage, so create new passage with the shared context
                    let bibleorgPassage = Passage(dictionary: results, dataArray: nil, sinID: self.sinID, entityName: ISINClient.EntityNames.ListPassage, context: self.sharedContext)
                    
                    // set flag for custom passage
                    bibleorgPassage.isCustom = true
                    
                    // append to array
                    self.passages.append(bibleorgPassage)
                    
                    
                    dispatch_async(dispatch_get_main_queue()){
                        // populate relevant arrays
                        self.populatePassageArrays()
                        
                        // clear selected indexes (fixes bug)
                        self.selectedIndexes.removeAll()
                        
                        // reload table
                        self.tableView.reloadData()
                    }
                    
                    // save the context
                    self.saveContext()
                }))
                
                // create no button
                alert.addAction(UIAlertAction(title: "NO", style: .Default, handler: nil))
                
                // present the alert
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            } else {
                
                // there was an error downloading, show alert
                ISINClient.sharedInstance().showAlert(self, title: "ERROR", message: errorString!, actions: ["OK"], completionHandler: nil)
            }
            
            // hide spinner and network indicator
            dispatch_async(dispatch_get_main_queue()){
                SwiftSpinner.hide()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            
        })
    }
    
    /* function that shows an alert when the button is pressed
     so that the user can input a custom passage to search for and add
     */
    @IBAction func addCustomPassageButtonPressed(sender: UIButton) {
        
        // create the alert
        let alert = UIAlertController(title: "Add Custom Passage", message: "Enter passage with format Book Chapter:Verse Start-VerseEnd", preferredStyle: .Alert)
        
        // add the textfield
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })
        
        // add the "add" action to add the passage
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            // get textfield and text
            let textField = alert.textFields![0] as UITextField
            
            // check the text
            if(textField.text! != ""){
                
                // proceed to get confirmation from user
                self.addCustomPassageConfirmAlert(textField.text!, sendingAlert: alert)
            }
        }))
        
        // add cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        
        // set needs layout (fixes bug)
        alert.view.setNeedsLayout()
        
        // present the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /* handle the press of the Add Record button */
    @IBAction func addRecordPressed(sender: UIButton) {
        
        // create a new record
        let newRecord = Record(context: sharedContext)
        
        // create a new sin for the record
        let newSin = RecordSin(name: self.sin.name, type: self.sin.type.integerValue, entityName: ISINClient.EntityNames.RecordSin, context: sharedContext)
        
        // iterate over all the selected indexpaths
        for i in 0 ..< selectedIndexes.count {
            
            // create a temporary passage
            let tempPassage: Passage!
            
            // determine if the passage is an api or custom passage (based on the section)
            // and set the temp passage
            if selectedIndexes[i].section == 0 {
                tempPassage = apiPassages[selectedIndexes[i].row]
            } else {
                tempPassage = customPassages[selectedIndexes[i].row]
            }
            
            // get the data from the passage
            let dataArray : [String: AnyObject] = [
                "book" : tempPassage.book,
                "chapter" : tempPassage.chapter,
                "verse_start" : tempPassage.start,
                "verse_end" : tempPassage.end
            ]
            
            // create a new passage for the record with the previous data
            let newPassage = RecordPassage(dictionary: nil, dataArray: dataArray, sinID: self.sinID, entityName: ISINClient.EntityNames.RecordPassage, context: sharedContext)
            
            // set the text and the passage's record (we would not be able to do this with a normal "Passage"
            newPassage.text = tempPassage.text
            newPassage.record = newRecord
        }
        
        // set the sin's record (we would not be able to do this with a normal "Sin")
        newSin.record = newRecord
        saveContext()
        
        // show an alert to tell the user that the record was added
        ISINClient.sharedInstance().showAlert(self, title: "Add Record Success!", message: "Sin record has been added!", actions: ["OK"]) { (choice) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
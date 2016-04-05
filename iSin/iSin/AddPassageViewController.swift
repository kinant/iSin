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
    var sin: Sin!
    var selectedIndexes = [NSIndexPath]()
    
    var apiPassages = [Passage]()
    var customPassages = [Passage]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        self.tableView.registerNib(UINib(nibName: "CustomPassageCellView", bundle: nil), forCellReuseIdentifier: "PassageCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        
        if self.navigationController != nil {
            print("does have navigation controller!")
            self.title = "Select Passages"
            
            let newRightButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddPassageViewController.cancelButtonPressed))
            let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: #selector(AddPassageViewController.refreshPressed))

            navigationItem.setRightBarButtonItems([newRightButton, refreshButton], animated: false)
        }
        
        self.passages = fetchAllPassages()
        
        if(passages.count == 0) {
            downloadData()
        }
        
        populatePassageArrays()
        tableView.reloadData()
        
    }
    
    func downloadData(){
        
        SwiftSpinner.show("Downloading...", description: "Downloading data from API", animated: true)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        ISINClient.sharedInstance().getPassagesForSin(self.sinID) { (results, errorString) in
            
            dispatch_async(dispatch_get_main_queue()){
                SwiftSpinner.hide()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            
            if((errorString == nil)){
                for i in 0 ..< results!.count {
                    let tempISINPassage = Passage(dictionary: nil, dataArray: results![i], sinID: self.sinID, entityName: ISINClient.EntityNames.ListPassage, context: self.scratchContext)
                    
                    ISINClient.sharedInstance().getPassage(tempISINPassage.title, completionHandlerForGetPassage: { (results, errorString) in
                        let bibleorgPassage = Passage(dictionary: results, dataArray: nil, sinID: self.sinID, entityName: ISINClient.EntityNames.ListPassage, context: self.sharedContext)
                        print(bibleorgPassage.text)
                        self.passages.append(bibleorgPassage)
                        
                        dispatch_async(dispatch_get_main_queue()){
                            print("will update table... ", self.passages.count)
                            self.populatePassageArrays()
                            self.selectedIndexes.removeAll()
                            self.tableView.reloadData()
                        }
                        
                        self.saveContext()
                    })
                }
            } else {
                ISINClient.sharedInstance().showAlert(self, title: "ERROR", message: errorString!, actions: ["OK"], completionHandler: nil)
            }
        }
    }
    
    func populatePassageArrays(){
        apiPassages.removeAll()
        customPassages.removeAll()

        for i in 0 ..< passages.count {
            if passages[i].isCustom {
                self.customPassages.append(passages[i])
            } else {
                self.apiPassages.append(passages[i])
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
        // find if the index is in selected indexes array
        selectedIndexes.append(indexPath)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if let index = selectedIndexes.indexOf(indexPath) {
            // remove it from the array
            selectedIndexes.removeAtIndex(index)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "API Sins"
        } else {
            return "Custom Sins"
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return apiPassages.count
        } else {
            return customPassages.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PassageCell") as! CustomPassageCellView
        
        if indexPath.section == 0 {
            cell.titleLabel.text = apiPassages[indexPath.row].title
            cell.passageTitle = apiPassages[indexPath.row].title
            cell.passageText = apiPassages[indexPath.row].text
        } else {
            cell.titleLabel.text = customPassages[indexPath.row].title
            cell.passageTitle = customPassages[indexPath.row].title
            cell.passageText = customPassages[indexPath.row].text
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
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
    
    func showPassageTextAlert(passageIndex: Int){
        let refreshAlert = UIAlertController(title: passages[passageIndex].title, message: passages[passageIndex].text, preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            //refreshAlert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    func addCustomPassageConfirmAlert(searchTerm: String, sendingAlert: UIAlertController){
        
        sendingAlert.view.removeFromSuperview()
        sendingAlert.removeFromParentViewController()
        sendingAlert.dismissViewControllerAnimated(false, completion: nil)
        
        SwiftSpinner.show("Downloading...", description: "Downloading data from API", animated: true)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        ISINClient.sharedInstance().getPassage(searchTerm, completionHandlerForGetPassage: { (results, errorString) in
            
            dispatch_async(dispatch_get_main_queue()){
                SwiftSpinner.hide()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false

            }
            
            if(errorString == nil){
                let bibleorgPassage = Passage(dictionary: results, dataArray: nil, sinID: self.sinID, entityName: ISINClient.EntityNames.ListPassage, context: self.sharedContext)
            
                let message = "Is this your passage: " + bibleorgPassage.title + "?"
            
                let alert = UIAlertController(title: "Confirm Passage", message: message , preferredStyle: .Alert)
            
                alert.addAction(UIAlertAction(title: "YES", style: .Default, handler: { (action) -> Void in
                    bibleorgPassage.isCustom = true
                    self.passages.append(bibleorgPassage)
                
                    dispatch_async(dispatch_get_main_queue()){
                        print("will update table... ", self.passages.count)
                        self.populatePassageArrays()
                        self.selectedIndexes.removeAll()
                        self.tableView.reloadData()
                    }
                
                    self.saveContext()
                }))
            
                alert.addAction(UIAlertAction(title: "NO", style: .Default, handler: { (action) -> Void in
                
                }))
            
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            } else {
                ISINClient.sharedInstance().showAlert(self, title: "ERROR", message: errorString!, actions: ["OK"], completionHandler: nil)
            }
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
        
        alert.view.setNeedsLayout()
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func getIndexOfAPISin(passage: Passage) -> Int? {
        for i in 0 ..< apiPassages.count {
            if passage.title == apiPassages[i].title {
                return i
            }
        }
        return nil
    }
    
    
    func refreshPressed() {
        // refresh pressed...
        apiPassages.removeAll()
        //customSins.removeAll()
        
        for i in 0 ..< passages.count {
            if !passages[i].isCustom {
                
                if let delIndex = getIndexOfAPISin(passages[i]){
                    let indexPath = NSIndexPath(forRow: delIndex, inSection: 0)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
                
                sharedContext.deleteObject(passages[i])
            }
        }
        
        tableView.reloadData()
        
        passages = fetchAllPassages()
        
        downloadData()
    }
    
    
    @IBAction func addRecordPressed(sender: UIButton) {
        
        let newSin = RecordSin(name: self.sin.name, type: self.sin.type.integerValue, entityName: ISINClient.EntityNames.RecordSin, context: sharedContext)
        let newRecord = Record(context: sharedContext)
        
        for i in 0 ..< selectedIndexes.count {
            let tempPassage: Passage!
            
            if selectedIndexes[i].section == 0 {
                tempPassage = apiPassages[selectedIndexes[i].row]
            } else {
                tempPassage = customPassages[selectedIndexes[i].row]
            }
            
            let dataArray : [String: AnyObject] = [
                "book" : tempPassage.book,
                "chapter" : tempPassage.chapter,
                "verse_start" : tempPassage.start,
                "verse_end" : tempPassage.end
            ]
            
            let newPassage = RecordPassage(dictionary: nil, dataArray: dataArray, sinID: self.sinID, entityName: ISINClient.EntityNames.RecordPassage, context: sharedContext)
            newPassage.text = tempPassage.text
            newPassage.record = newRecord
            
            print("ADDING PASSAGE: ", newPassage.title)
            
        }
        
        newSin.record = newRecord
        saveContext()
        
        ISINClient.sharedInstance().showAlert(self, title: "Add Record Success!", message: "Sin record has been added!", actions: ["OK"]) { (choice) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
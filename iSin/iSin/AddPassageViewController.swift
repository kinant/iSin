//
//  AddPassageViewController.swift
//  iSin
//
//  Created by Kinan Turman on 4/2/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation

class AddPassageViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sinID:Int!
    var passages = [ISINPassage]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PassageCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        ISINClient.sharedInstance().getPassagesForSin(self.sinID) { (results, errorString) in
            
            if((errorString == nil)){
                for i in 0 ..< results.count {
                    let tempISINPassage = ISINPassage(dictionaryArray: results[i])
                    
                    ISINClient.sharedInstance().getPassage(tempISINPassage.title, completionHandlerForGetPassage: { (results, errorString) in
                        let bibleorgPassage = ISINPassage(dictionaryArray: results)
                        print(bibleorgPassage.text)
                        self.passages.append(bibleorgPassage)
                        
                        dispatch_async(dispatch_get_main_queue()){
                            print("will update table... ", self.passages.count)
                            self.tableView.reloadData()
                        }
                    })
                }
            }
        }
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
            
            let bibleorgPassage = ISINPassage(dictionaryArray: results)
            
            let message = "Is this your passage: " + bibleorgPassage.title + "?"
            
            let alert = UIAlertController(title: "Confirm Passage", message: message , preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "YES", style: .Default, handler: { (action) -> Void in
                self.passages.append(bibleorgPassage)
                
                dispatch_async(dispatch_get_main_queue()){
                    print("will update table... ", self.passages.count)
                    self.tableView.reloadData()
                }
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
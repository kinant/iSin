//
//  AddSinViewController.swift
//  iSin
//
//  Created by Kinan Turman on 3/22/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation

class AddSinViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {

    var sinID:Int!
    var sins = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SinCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        ISINClient.sharedInstance().getSinsCommitedForSinType(self.sinID) { (results, errorString) in
            // do smething...
            
            for(var i=0; i<results.count; i++){
                print(results[i])
                self.sins = results
            }
            
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
            }
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
        cell?.textLabel?.text = sins[indexPath.row]
        return cell!
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
                
                self.sins.append(textField.text!)
                
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
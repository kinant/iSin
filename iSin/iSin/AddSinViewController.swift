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
}
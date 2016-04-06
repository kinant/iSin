//
//  RecordDetailViewController.swift
//  iSin
//
//  Created by Kinan Turman on 4/4/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation

class RecordDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Outlet variables
    @IBOutlet weak var sinLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties and variables
    var record: Record!
    var passages = [Passage]()
    var sinNames = ["LUST", "GLUTTONY", "GREED", "SLOTH", "WRATH", "ENVY", "PRIDE"]
    
    // MARK: View functions
    override func viewDidLoad() {
        
        // register the class so we can use custom cell view
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "RecordPassageCell")
        
        // set deletage and source
        tableView.delegate = self
        tableView.dataSource = self
        
        // set the passages array to the passages inside the record
        // we do it this way since passages are stored as an
        // NSSet
        passages = (record.passages!.allObjects as? [Passage])!
        
        // set labels
        self.sinLabel.text = record.sin.name
        self.dateLabel.text = record.dateString
        self.typeLabel.text = sinNames[record.sin.type.integerValue - 1]
    }
    
    /* function for the number of rows */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return record.passages!.count
    }
    
    /* function for the creation of each cell in the tableview */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RecordPassageCell")        
        
        // set title and text color
        cell?.textLabel?.text = passages[indexPath.row].title
        cell?.textLabel?.textColor = UIColor.whiteColor()
        
        return cell!
    }
    
    /* function to handle the selection of a tableview row */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // show alert with passage info
        ISINClient.sharedInstance().showAlert(self, title: passages[indexPath.row].title, message: passages[indexPath.row].text, actions: ["OK"], completionHandler: nil)
    }
}
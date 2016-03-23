//
//  SinTableViewController.swift
//  iSin
//
//  Created by Kinan Turman on 3/23/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation
import UIKit

class SinTableViewController : UITableViewController {

    var sins = [String]()

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SinCell")
        
        cell?.textLabel?.text = sins[indexPath.row]
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sins.count
    }
}
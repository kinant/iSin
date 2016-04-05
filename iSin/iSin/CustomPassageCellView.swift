//
//  CustomPassageCellView.swift
//  iSin
//
//  Created by Kinan Turman on 4/4/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation


import Foundation
import UIKit

class CustomPassageCellView: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    var passageTitle: String!
    var passageText: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func readPassageButtonPressed(){
        // call the alert and show the passage title and text
        // the alert target is the presented view controller (from the root)
        ISINClient.sharedInstance().showAlert((self.window?.rootViewController?.presentedViewController)!, title: passageTitle, message: passageText, actions: ["OK"], completionHandler: nil)
    }
}
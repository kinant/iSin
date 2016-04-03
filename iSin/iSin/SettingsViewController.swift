//
//  SettingsViewController.swift
//  iSin
//
//  Created by Kinan Turman on 4/3/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation

class SettingsViewController:UIViewController {
    
    
    @IBOutlet weak var prefSinButton: UIButton!
    
    var sinNames = ["LUST", "GLUTTONY", "GREED", "SLOTH", "WRATH", "ENVY", "PRIDE"]
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func prefSinButtonPressed(sender: UIButton) {
    
        let actionSheet = UIAlertController(title: "Sins", message: "Select A Sin", preferredStyle: UIAlertControllerStyle.ActionSheet)
    
        
        for i in 0 ..< sinNames.count {
            
            actionSheet.addAction(UIAlertAction(title: sinNames[i], style: .Default, handler: { (action) -> Void in
                self.prefSinButton.setTitle(self.sinNames[i], forState: .Normal)
            }))
        }
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
}

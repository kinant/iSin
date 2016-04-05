//
//  SettingsViewController.swift
//  iSin
//
//  Created by Kinan Turman on 4/3/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation

class SettingsViewController:UIViewController {
    
    @IBOutlet weak var authSwitch: UISwitch!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var sinNames = ["LUST", "GLUTTONY", "GREED", "SLOTH", "WRATH", "ENVY", "PRIDE"]
    
    override func viewDidLoad() {
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
        }
        
        authSwitch.setOn(NSUserDefaults.standardUserDefaults().boolForKey("authAll"), animated: false)
        
    }
    
    @IBAction func switchPressed(sender: UISwitch) {
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: "authAll")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

}

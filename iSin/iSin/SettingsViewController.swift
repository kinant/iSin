//
//  SettingsViewController.swift
//  iSin
//
//  Created by Kinan Turman on 4/3/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation

/* View controller for the settings view */
class SettingsViewController:UIViewController {
    
    @IBOutlet weak var authSwitch: UISwitch! // for the switch to select if user wants to authorize all the time
    @IBOutlet weak var menuButton: UIBarButtonItem! // to show the menu
    
    // list of all the sin names
    var sinNames = ["LUST", "GLUTTONY", "GREED", "SLOTH", "WRATH", "ENVY", "PRIDE"]
    
    override func viewDidLoad() {
        
        // for toggling the menu (SWRevealViewController)
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
        }
        
        // set the switch to the saved value
        authSwitch.setOn(NSUserDefaults.standardUserDefaults().boolForKey("authAll"), animated: false)
        
    }
    
    /* handle the switch. this switch allows the user to select wether or not they want
        to have to authorize the app everytime it becomes active
     */
    @IBAction func switchPressed(sender: UISwitch) {
        
        // set the value in NSUserDefaults and sync
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: "authAll")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

}

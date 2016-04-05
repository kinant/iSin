//
//  SinViewController.swift
//  iSin
//
//  Created by Kinan Turman on 3/21/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation
import UIKit

/* This view controller handles the view of the sin screen */
class SinViewController: UIViewController {

    // properties
    @IBOutlet weak var titleLabel: UILabel! // the title of the screen is the sin
    @IBOutlet weak var addButton: UIButton! // button to add a sin
    @IBOutlet weak var descLabel: UILabel! // description of the sin
    
    var bckColor: UIColor! // background color
    var sinTitle: String! // the title
    var sinDescription: String! // the description
    var sinID:Int! // the sin id index
    
    override func viewWillAppear(animated: Bool) {
        
        // set background and labels
        self.view.backgroundColor = bckColor
        self.titleLabel.text = sinTitle
        self.titleLabel.textColor = UIColor.whiteColor()
        
        self.titleLabel.layer.shadowOpacity = 0.75
        self.titleLabel.layer.shadowRadius = 0.0
        self.titleLabel.layer.shadowColor = UIColor.blackColor().CGColor
        self.titleLabel.layer.shadowOffset = CGSizeMake(-1.0, 1.0)
        
        descLabel.text = sinDescription
    }
    
    // handle the press of the add button to add a sin
    @IBAction func addSinPressed(sender: UIButton) {
        
        // show the add sin screen
        let addSinNavC = storyboard?.instantiateViewControllerWithIdentifier("AddSinNavController") as! AddSinNavigationController
        addSinNavC.sinID = self.sinID
        
        // since this view is managed by the SWRevealViewController, we must call presentViewController from the rootViewController
        self.view.window!.rootViewController!.presentViewController(addSinNavC, animated: true, completion: nil)
    }
}

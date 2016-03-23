//
//  SinViewController.swift
//  iSin
//
//  Created by Kinan Turman on 3/21/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation
import UIKit

class SinViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var descTextView: UITextView!
    
    var bckColor: UIColor!
    var sinTitle: String!
    var sinDescription: String!
    var sinID:Int!
    
    override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = bckColor
        self.titleLabel.text = sinTitle
        self.titleLabel.textColor = UIColor.whiteColor()
        //self.titleLabel.font
        
        self.titleLabel.layer.shadowOpacity = 0.75
        self.titleLabel.layer.shadowRadius = 0.0
        self.titleLabel.layer.shadowColor = UIColor.blackColor().CGColor
        self.titleLabel.layer.shadowOffset = CGSizeMake(-1.0, 1.0)
        
        descTextView.text = sinDescription
    }
    
    @IBAction func addSinPressed(sender: UIButton) {
        let addSinVC = storyboard?.instantiateViewControllerWithIdentifier("AddSin") as! AddSinViewController
        
        addSinVC.sinID = self.sinID
        
        print("sin id will be: ", self.sinID)
        
        presentViewController(addSinVC, animated: true, completion: nil)
    }
}

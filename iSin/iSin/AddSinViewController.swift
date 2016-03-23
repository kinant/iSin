//
//  AddSinViewController.swift
//  iSin
//
//  Created by Kinan Turman on 3/22/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation

class AddSinViewController:UIViewController {

    var sinID:Int!
    
    override func viewDidLoad() {
        ISINClient.sharedInstance().getSinsCommitedForSinType(self.sinID) { (results, errorString) in
            // do smething...
            
            for(var i=0; i<results.count; i++){
                print(results[i])
            }
        }
    }
    
    
    @IBAction func cancelPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}
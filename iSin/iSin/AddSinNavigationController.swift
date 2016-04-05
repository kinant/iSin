//
//  AddSinNavigationController.swift
//  iSin
//
//  Created by Kinan Turman on 4/3/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation

/* This class is necessary so that the sinid can be transferred to the Add Sin View Controller */
class AddSinNavigationController: UINavigationController {
    
    var sinID:Int!
    
    override func viewDidLoad() {
        let addSinVC = self.viewControllers.first! as! AddSinViewController
        addSinVC.sinID = sinID
    }
}
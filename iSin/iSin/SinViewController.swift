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
    
    override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = bckColor
        self.titleLabel.text = sinTitle
        descTextView.text = sinDescription
    }
    
}

//
//  ViewController.swift
//  iSin
//
//  Created by Kinan Turman on 3/21/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import UIKit

class ViewController: PagerController, PagerDataSource {
    
    var titles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        // Instantiating Storyboard ViewControllers
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller1 = storyboard.instantiateViewControllerWithIdentifier("SinView") as! SinViewController
        controller1.sinTitle = "LUST"
        controller1.bckColor = UIColor.blueColor();
        
        let controller2 = storyboard.instantiateViewControllerWithIdentifier("SinView") as! SinViewController
        controller2.sinTitle = "GLUTTONY"
        controller2.bckColor = UIColor.brownColor()
        
        let controller3 = storyboard.instantiateViewControllerWithIdentifier("SinView") as! SinViewController
        controller3.sinTitle = "GREED"
        controller3.bckColor = UIColor.orangeColor()
        
        let controller4 = storyboard.instantiateViewControllerWithIdentifier("SinView") as! SinViewController
        controller4.sinTitle = "SLOTH"
        controller4.bckColor = UIColor.yellowColor()
        
        let controller5 = storyboard.instantiateViewControllerWithIdentifier("SinView") as! SinViewController
        controller5.sinTitle = "WRATH"
        controller5.bckColor = UIColor.whiteColor()
        
        let controller6 = storyboard.instantiateViewControllerWithIdentifier("SinView") as! SinViewController
        controller6.sinTitle = "ENVY"
        controller6.bckColor = UIColor.redColor()
        
        let controller7 = storyboard.instantiateViewControllerWithIdentifier("SinView") as! SinViewController
        controller7.sinTitle = "PRIDE"
        controller7.bckColor = UIColor.greenColor()
        
        // Setting up the PagerController with Name of the Tabs and their respective ViewControllers
        self.setupPager(
            tabNames: ["lust", "gluttony", "greed", "sloth", "wrath", "envy", "pride"],
            tabControllers: [controller1, controller2, controller3, controller4, controller5, controller6, controller7])
        
        customiseTab()
    }
    
    // Customising the Tab's View
    func customiseTab()
    {
        indicatorColor = UIColor.whiteColor()
        tabsViewBackgroundColor = UIColor(rgb: 0x00AA00)
        contentViewBackgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.32)
        
        startFromSecondTab = false
        centerCurrentTab = false
        tabLocation = PagerTabLocation.Top
        tabHeight = 49
        tabOffset = 36
        tabWidth = 96.0
        fixFormerTabsPositions = false
        fixLaterTabsPosition = false
        animation = PagerAnimation.During
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Programatically selecting a tab. This function is getting called on AppDelegate
    func changeTab() {
        //self.selectTabAtIndex(4)
    }
}



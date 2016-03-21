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
    
    internal enum Sin: Int {
        case Lust = 0 //None will go to the bottom
        case Gluttony = 1
        case Greed = 2
        case Sloth = 3
        case Wrath = 4
        case Envy = 5
        case Pride = 6
    }
    
    var descriptions = [
        "to have an intense desire or need",
        "excess in eating and drinking",
        "excessive or reprehensible acquisitiveness",
        "disinclined to activity or exertion: not energetic or vigorous",
        "strong vengeful anger or indignation",
        "painful or resentful awareness of an advantage enjoyed by another joined with a desire to possess the same advantag",
        "quality or state of being proud – inordinate self esteem"
    ];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        // Instantiating Storyboard ViewControllers
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let controller1 = storyboard.instantiateViewControllerWithIdentifier("SinView") as! SinViewController
        controller1.sinTitle = "LUST"
        controller1.bckColor = UIColor.blueColor();
        controller1.sinDescription = descriptions[0]
        
        let controller2 = storyboard.instantiateViewControllerWithIdentifier("SinView") as! SinViewController
        controller2.sinTitle = "GLUTTONY"
        controller2.bckColor = UIColor.brownColor()
        controller2.sinDescription = descriptions[1]
        
        let controller3 = storyboard.instantiateViewControllerWithIdentifier("SinView") as! SinViewController
        controller3.sinTitle = "GREED"
        controller3.bckColor = UIColor.orangeColor()
        controller3.sinDescription = descriptions[2]
        
        let controller4 = storyboard.instantiateViewControllerWithIdentifier("SinView") as! SinViewController
        controller4.sinTitle = "SLOTH"
        controller4.bckColor = UIColor.yellowColor()
        controller4.sinDescription = descriptions[3]
        
        let controller5 = storyboard.instantiateViewControllerWithIdentifier("SinView") as! SinViewController
        controller5.sinTitle = "WRATH"
        controller5.bckColor = UIColor.whiteColor()
        controller5.sinDescription = descriptions[4]
        
        let controller6 = storyboard.instantiateViewControllerWithIdentifier("SinView") as! SinViewController
        controller6.sinTitle = "ENVY"
        controller6.bckColor = UIColor.redColor()
        controller6.sinDescription = descriptions[5]
        
        let controller7 = storyboard.instantiateViewControllerWithIdentifier("SinView") as! SinViewController
        controller7.sinTitle = "PRIDE"
        controller7.bckColor = UIColor.greenColor()
        controller7.sinDescription = descriptions[6]
        
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



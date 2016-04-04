//
//  ViewController.swift
//  iSin
//
//  Created by Kinan Turman on 3/21/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import UIKit

class ViewController: PagerController, PagerDataSource {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
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
        "To have intense desire or need",
        "Excess in eating and drinking",
        "Excessive or reprehensible acquisitiveness",
        "Disinclined to activity or exertion: not energetic or vigorous",
        "Strong vengeful anger or indignation",
        "Painful or resentful awareness of an advantage enjoyed by another joined with a desire to possess the same advantage",
        "Quality or state of being proud – inordinate self esteem"
    ];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.dataSource = self
        
        // Instantiating Storyboard ViewControllers
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let controller1 = storyboard.instantiateViewControllerWithIdentifier("SinView") as! SinViewController
        controller1.sinTitle = "LUST"
        controller1.bckColor = "#F08080".hexColor
        controller1.sinDescription = descriptions[0]
        controller1.sinID = 1
        
        let controller2 = storyboard.instantiateViewControllerWithIdentifier("SinView") as! SinViewController
        controller2.sinTitle = "GLUTTONY"
        controller2.bckColor = "#FF69B4".hexColor
        controller2.sinDescription = descriptions[1]
        controller2.sinID = 2
        
        let controller3 = storyboard.instantiateViewControllerWithIdentifier("SinView") as! SinViewController
        controller3.sinTitle = "GREED"
        controller3.bckColor = "#FFFF00".hexColor
        controller3.sinDescription = descriptions[2]
        controller3.sinID = 3
        
        let controller4 = storyboard.instantiateViewControllerWithIdentifier("SinView") as! SinViewController
        controller4.sinTitle = "SLOTH"
        controller4.bckColor = "#87CEFA".hexColor
        controller4.sinDescription = descriptions[3]
        controller4.sinID = 4
        
        let controller5 = storyboard.instantiateViewControllerWithIdentifier("SinView") as! SinViewController
        controller5.sinTitle = "WRATH"
        controller5.bckColor = "#FFA500".hexColor
        controller5.sinDescription = descriptions[4]
        controller5.sinID = 5
        
        let controller6 = storyboard.instantiateViewControllerWithIdentifier("SinView") as! SinViewController
        controller6.sinTitle = "ENVY"
        controller6.bckColor = "#32CD32".hexColor
        controller6.sinDescription = descriptions[5]
        controller6.sinID = 6
        
        let controller7 = storyboard.instantiateViewControllerWithIdentifier("SinView") as! SinViewController
        controller7.sinTitle = "PRIDE"
        controller7.bckColor = "#EE82EE".hexColor
        controller7.sinDescription = descriptions[6]
        controller7.sinID = 7
        
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
        tabsViewBackgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.45)
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



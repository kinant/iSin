//
//  AppDelegate.swift
//  iSin
//
//  Created by Kinan Turman on 3/21/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //NavigationBar customization
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()] // Title's text color
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = "#FF0000".hexColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        //TableView customization
        UITableView.appearance().backgroundColor = "#CC6666".hexColor
        UITableViewCell.appearance().backgroundColor = "#FF3333".hexColor
        UITableViewCell.appearance().alpha = 0.75
        
        //Setting Status Bar to be white instead of black
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
        print("WILL RESIGN ACTIVE")
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("DID ENTER BACKGROUND")
        
        if(NSUserDefaults.standardUserDefaults().boolForKey("authAll")){
            ISINClient.sharedInstance().userLoggedIn = false
        }
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        print("WILL ENTER FOREGROUND")
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("DID BECOME ACTIVE! ", self.window?.rootViewController?.presentedViewController)
        
        
        
        if(!ISINClient.sharedInstance().userLoggedIn && !ISINClient.Platform.isSimulator){
            
            let presentVC = self.window?.rootViewController?.presentedViewController
            
            if(presentVC != nil && (presentVC?.isKindOfClass(AuthenticateViewController))!){
            } else {
                let authVC = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("AuthenticateVC") as! AuthenticateViewController
                self.window?.rootViewController?.presentViewController(authVC, animated: false, completion: nil)
            }
        }
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
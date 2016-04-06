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
        
        // NavigationBar customization
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()] // Title's text color
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = "#FF0000".hexColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        // TableView customization
        UITableView.appearance().backgroundColor = "#CC6666".hexColor
        UITableViewCell.appearance().backgroundColor = "#FF3333".hexColor
        UITableViewCell.appearance().alpha = 0.75
        
        // Setting Status Bar
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        
        /*  if the user has chosen the option to authorize everytime the app is active, then we should log the user off the app everytime
            it enters the background */
        if(NSUserDefaults.standardUserDefaults().boolForKey("authAll")){
            ISINClient.sharedInstance().userLoggedIn = false
        }
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {

        // the following is done so that the user authorization (with TouchID) screen is called
        
        // first we check that the user is not logged in and that the platform is not the iOS simulator
        if(!ISINClient.sharedInstance().userLoggedIn && !ISINClient.Platform.isSimulator){
            
            // get the presented view controller by the root view controller
            let presentVC = self.window?.rootViewController?.presentedViewController
            
            // we have to check that the presented view controller is NOT nil and that it is NOT the
            // view controller for the authentication screen
            if(presentVC != nil && (presentVC?.isKindOfClass(AuthenticateViewController))!){
                // do nothing in this case (we do not show the authorization screen)
            } else {
                
                // all criteria is not met, we present the authorization screen
                // remove these lines to disable authentication
                let authVC = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("AuthenticateVC") as! AuthenticateViewController
                self.window?.rootViewController?.presentViewController(authVC, animated: false, completion: nil)
            }
        }
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
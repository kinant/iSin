//
//  AuthenticateViewController.swift
//  iSin
//
//  Created by Kinan Turman on 4/4/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthenticateViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    let MyKeychainWrapper = KeychainWrapper()
    var spinner: SwiftSpinner!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        // authenticateUser()
        
        let hasLoginKey = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
        
        print("has log in? ", hasLoginKey)
        
        if(!hasLoginKey) {
            showPasswordCreateAlert()
        } else {
            authenticateUser()
        }
    }
    
    
    func setupData() {
        self.statusLabel.text = "Unknown user"
    }
    
    func authenticateUser() {
        let touchIDManager : PITouchIDManager = PITouchIDManager()
        
        touchIDManager.authenticateUser(success: { () -> () in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.loadDada()
                
                SwiftSpinner.show("User authenticated!", description: "Starting app", animated: true)
                
                self.authenticateSuccess()
            })
            }, failure: { (evaluationError: NSError) -> () in
                switch evaluationError.code {
                case LAError.SystemCancel.rawValue:
                    print("Authentication cancelled by the system")
                    self.statusLabel.text = "Authentication cancelled by the system"
                case LAError.UserCancel.rawValue:
                    print("Authentication cancelled by the user")
                    self.statusLabel.text = "Authentication cancelled by the user"
                case LAError.UserFallback.rawValue:
                    print("User wants to use a password")
                    self.statusLabel.text = "User wants to use a password"
                    // We show the alert view in the main thread (always update the UI in the main thread)
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.showPasswordAlert()
                    })
                case LAError.TouchIDNotEnrolled.rawValue:
                    print("TouchID not enrolled")
                    self.statusLabel.text = "TouchID not enrolled"
                case LAError.PasscodeNotSet.rawValue:
                    print("Passcode not set")
                    self.statusLabel.text = "Passcode not set"
                default:
                    print("Authentication failed")
                    self.statusLabel.text = "Authentication failed"
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.showPasswordAlert()
                    })
                }
        })
    }
    
    func loadDada() {
        self.statusLabel.text = "User authenticated"
    }
    
    func showPasswordAlert() {
        // New way to present an alert view using UIAlertController
        let alertController : UIAlertController = UIAlertController(title:"TouchID Demo" , message: "Please enter password", preferredStyle: .Alert)
        
        // We define the actions to add to the alert controller
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            print(action)
        }
        let doneAction : UIAlertAction = UIAlertAction(title: "Done", style: .Default) { (action) -> Void in
            let passwordTextField = alertController.textFields![0] as UITextField
            if let text = passwordTextField.text {
                self.login(text)
            }
        }
        doneAction.enabled = false
        
        // We are customizing the text field using a configuration handler
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification) -> Void in
                doneAction.enabled = textField.text != ""
            })
        }
        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)
        
        self.presentViewController(alertController, animated: true) {
            // Nothing to do here
        }
    }
    
    func showPasswordCreateAlert() {
        // New way to present an alert view using UIAlertController
        let alertController : UIAlertController = UIAlertController(title:"TouchID Demo" , message: "Please enter a new password", preferredStyle: .Alert)
        
        // We define the actions to add to the alert controller
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            print(action)
        }
        let doneAction : UIAlertAction = UIAlertAction(title: "Done", style: .Default) { (action) -> Void in
            let passwordTextField = alertController.textFields![0] as UITextField
            if let text = passwordTextField.text {
                //self.login(text)
                print("****** WILL SET PASSWORD ******: ", text)
                self.showConfirmPasswordCreateAlert(text, message: "Please confirm password" , shakeView: false)
            }
        }
        doneAction.enabled = false
        
        // We are customizing the text field using a configuration handler
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification) -> Void in
                doneAction.enabled = textField.text != ""
            })
        }
        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)
        
        dispatch_async(dispatch_get_main_queue()){
            self.presentViewController(alertController, animated: true) {
                // Nothing to do here
            }
        }
    }
    
    func showConfirmPasswordCreateAlert(password: String, message: String, shakeView: Bool) {
        // New way to present an alert view using UIAlertController
        let alertController : UIAlertController = UIAlertController(title:"TouchID Demo" , message: message, preferredStyle: .Alert)
        
        // We define the actions to add to the alert controller
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            print(action)
        }
        let doneAction : UIAlertAction = UIAlertAction(title: "Confirm", style: .Default) { (action) -> Void in
            let passwordTextField = alertController.textFields![0] as UITextField
            if let text = passwordTextField.text {
                //self.login(text)
                print("****** IS SET PASSWORD? ******: ", text == password)
                
                if(text == password) {
                    // set the password...
                    self.MyKeychainWrapper.mySetObject(text, forKey:kSecValueData)
                    self.MyKeychainWrapper.writeToKeychain()
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                } else {
                    dispatch_async(dispatch_get_main_queue()){
                        self.showConfirmPasswordCreateAlert(password, message: "Passwords do not match!", shakeView: true)
                    }
                }
            }
        }
        doneAction.enabled = false
        
        // We are customizing the text field using a configuration handler
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification) -> Void in
                doneAction.enabled = textField.text != ""
            })
        }
        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)
        
        self.presentViewController(alertController, animated: true) {
            
            if(shakeView){
                self.shakeView(alertController.view!)
            }
            
        }
    }
    
    func shakeView(sview: UIView){
        
        let animation = CABasicAnimation(keyPath: "position")
        
        animation.duration = 0.05
        
        animation.repeatCount = 5
        
        animation.autoreverses = true
        
        animation.fromValue = NSValue(CGPoint: CGPointMake(sview.center.x - 10, sview.center.y))
        
        animation.toValue = NSValue(CGPoint: CGPointMake(sview.center.x + 10, sview.center.y))
        
        sview.layer.addAnimation(animation, forKey: "position")
    }
    
    func login(password: String) {

        if password == MyKeychainWrapper.myObjectForKey("v_Data") as? String {
            self.loadDada()
            
        } else {
            self.showPasswordAlert()
        }
    }
    
    @IBAction func authenticateButtonPressed(sender: UIButton) {
        authenticateUser()
    }
    
    func authenticateSuccess(){
        
        ISINClient.sharedInstance().userLoggedIn = true
        
        let delay = 1.5 * Double(NSEC_PER_SEC)
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue()) {
            SwiftSpinner.hide()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

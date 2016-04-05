//
//  ISINClient.swift
//  iSin
//
//  Created by Kinan Turman on 3/22/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation
import UIKit

class ISINClient: NSObject {
    
    // MARK: Properties
    var session: NSURLSession // for storing the session
    var userID: String? = nil // for storing user's Udacity ID Key
    var sessionID: String? = nil // for storing user's Udacity session ID
    var FBaccessToken: String? = nil // for storing FB access token
    
    var userLoggedIn = false
    
    // MARK: init
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: GET
    // function for GET network data requests
    func taskForGETMethod(api: ISINClient.API, method: String, params: [String:AnyObject], completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        //parameters[ParameterKeys.ApiKey] = Constants.ApiKey
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: urlFromParameters(params, withPathExtension: method, api: api))
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            var newData = data;
            
            // newData = data.subdataWithRange(NSMakeRange(1, data.length-3))
            
            //let responseString = NSString(data: newData, encoding: NSUTF8StringEncoding)
            //print(responseString)
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: OTHER FUNCTIONS - HELPER FUNCTIONS
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    // create a URL from parameters
    private func urlFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil, api: ISINClient.API) -> NSURL {
        
        let components = NSURLComponents()
        
        if(api == ISINClient.API.BIBLEORG){
            components.scheme = ISINClient.BIBLEORGConstants.ApiScheme
            components.host = ISINClient.BIBLEORGConstants.ApiHost
            components.path = ISINClient.BIBLEORGConstants.ApiPath + (withPathExtension ?? "")
            components.queryItems = [NSURLQueryItem]()
        } else {
            components.scheme = ISINClient.ISINConstants.ApiScheme
            components.host = ISINClient.ISINConstants.ApiHost
            components.path = ISINClient.ISINConstants.ApiPath + (withPathExtension ?? "")
            components.queryItems = [NSURLQueryItem]()
        }
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        print("url should be: ", components.URL!)
        
        return components.URL!
    }
    
    /* Helper function: Display an alert. The entire app can use this same function for alerts, which is why it has
     a completion handler as a closure */
    func showAlert(view: UIViewController, title: String, message: String, actions: [String] , completionHandler: ((choice: String?) -> Void )?){
        
        // make sure no alert is already being presented
        if !(view.presentedViewController is UIAlertController) {
            
            // create the alert
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            
            // iterate over every action to create its option in the alert
            for action in actions {
                alert.addAction(UIAlertAction(title: action, style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                    
                    // call completion handler if it exists
                    if let handler = completionHandler {
                        handler(choice: action)
                    }
                }))
            }
            
            // present the alert
            dispatch_async(dispatch_get_main_queue()){
                view.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

    
    struct Platform {
        static let isSimulator: Bool = {
            var isSim = false
            #if arch(i386) || arch(x86_64)
                isSim = true
            #endif
            return isSim
        }()
    }
    
    // MARK: - Shared Instance
    class func sharedInstance() -> ISINClient {
        
        struct Singleton {
            static var sharedInstance = ISINClient()
        }
        
        return Singleton.sharedInstance
    }
}


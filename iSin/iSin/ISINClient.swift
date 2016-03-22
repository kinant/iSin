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
    
    // MARK: init
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: GET
    // function for GET network data requests
    func taskForGETMethod(method: String, var parameters: [String:AnyObject], completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        //parameters[ParameterKeys.ApiKey] = Constants.ApiKey
        
        var url = "http://labs.bible.org/api/?passage=1Jn3:16&type=json";
        var myURL = NSURL(string: url)
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: urlFromParameters(parameters, withPathExtension: method))
        
        //let request = NSMutableURLRequest(URL: myURL!)
        
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
    private func urlFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = ISINClient.Constants.ApiScheme
        components.host = ISINClient.Constants.ApiHost
        components.path = ISINClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    // MARK: - Shared Instance
    class func sharedInstance() -> ISINClient {
        
        struct Singleton {
            static var sharedInstance = ISINClient()
        }
        
        return Singleton.sharedInstance
    }
}


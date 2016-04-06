//
//  ISINConvenience.swift
//  iSin
//
//  Created by Kinan Turman on 3/22/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation

extension ISINClient {
    
    // this stuct is used to check if the platform is the simulator or device
    // from: http://themainthread.com/blog/2015/06/simulator-check-in-swift.html
    struct Platform {
        static let isSimulator: Bool = {
            var isSim = false
            #if arch(i386) || arch(x86_64)
                isSim = true
            #endif
            return isSim
        }()
    }
    
    /* This function is used to get the list of sins commited for a type of sin from the iSin API.*/
    func getSinsCommitedForSinType(type:Int, completionHandlerForSinsCommited: (results: [String]?, errorString: String?) -> Void){
        
        // set the parameters
        let parameters = [
            "sin_id": type,
        ]
        
        // make the request
        taskForGETMethod(API.ISIN, method: "get_sins", params: parameters) { (result, error) in
            
            // check for errors
            if(error == nil){
                
                // no error, get the data and call the completion handler
                if let sinsCommitted = result["results"] as? [String] {
                    completionHandlerForSinsCommited(results: sinsCommitted, errorString: nil)
                }
            } else {
                // there was an error
                completionHandlerForSinsCommited(results: nil, errorString: error?.userInfo[NSLocalizedDescriptionKey] as? String)
            }
        }
    }
    
    /* This function is used to get the list of passages for a type of sin from the iSin API.*/
    func getPassagesForSin(sinID: Int, completionHandlerForGetPassages: (results:[[String:AnyObject]]?, errorString: String?)-> Void){
        
        // set the parameters
        let parameters = [
            "sin_id": sinID,
        ]
        
        // make the request
        taskForGETMethod(ISINClient.API.ISIN, method: "get_passages", params: parameters) { (result, error) in
            
            // check for errors
            if(error == nil){
                
                // no errors, get data and call completion handler
                if let resultsArray = result["results"] as? [[String:AnyObject]]{
                    completionHandlerForGetPassages(results: resultsArray, errorString: nil)
                }
            } else {
                // there was an error
                completionHandlerForGetPassages(results: nil, errorString: error?.userInfo[NSLocalizedDescriptionKey] as? String)
            }
        }
    }
    
    /* This function is used to get the passage text from the Bible-Org API.*/
    func getPassage(searchTerm: String, completionHandlerForGetPassage: (results:[[String:AnyObject]]?, errorString: String?)-> Void){
        
        // set the parameters
        let parameters = [
            "passage": searchTerm,
            "type": "json"
        ]
        
        // make the request
        taskForGETMethod(ISINClient.API.BIBLEORG, method: "", params: parameters) { (result, error) in
            
            // check for errors
            if(error == nil){
                
                // no errors, get the data and call completion handler
                if let resultsArray = result as? [[String:AnyObject]]{
                    completionHandlerForGetPassage(results: resultsArray, errorString: nil)
                }
            } else {
                
                // there was an error
                completionHandlerForGetPassage(results: nil, errorString: error?.userInfo[NSLocalizedDescriptionKey] as? String)
            }
        }
    }
}
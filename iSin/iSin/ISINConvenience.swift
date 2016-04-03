//
//  ISINConvenience.swift
//  iSin
//
//  Created by Kinan Turman on 3/22/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation

extension ISINClient {

    func getSinsCommitedForSinType(type:Int, completionHandlerForSinsCommited: (results: [String], errorString: String?) -> Void){
        
        let parameters = [
            "sin_id": type,
        ]
        
        taskForGETMethod(API.ISIN, method: "get_sins", params: parameters) { (result, error) in
            //print(result)
            if let sinsCommitted = result["results"] as? [String] {
                //print(sinsCommited)
                completionHandlerForSinsCommited(results: sinsCommitted, errorString: nil);
            }
        }
    }
    
    func getPassagesForSin(sinID: Int, completionHandlerForGetPassages: (results:[[String:AnyObject]], errorString: String?)-> Void){
        
        let parameters = [
            "sin_id": sinID,
        ]
        
        taskForGETMethod(ISINClient.API.ISIN, method: "get_passages", params: parameters) { (result, error) in
            
            //print(result["results"])
            if let resultsArray = result["results"] as? [[String:AnyObject]]{
                completionHandlerForGetPassages(results: resultsArray, errorString: nil)
            }
        }
    }
    
    func getPassage(searchTerm: String, completionHandlerForGetPassage: (results:[[String:AnyObject]], errorString: String?)-> Void){
        let parameters = [
            "passage": searchTerm,
            "type": "json"
        ]
        
        taskForGETMethod(ISINClient.API.BIBLEORG, method: "", params: parameters) { (result, error) in
            if(error == nil){
                if let resultsArray = result as? [[String:AnyObject]]{
                    completionHandlerForGetPassage(results: resultsArray, errorString: nil)
                }
            }
        }
    }
}

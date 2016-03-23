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
            "sin_id": 1,
        ]
        
        taskForGETMethod(API.ISIN, method: "get_sins", parameters: parameters) { (result, error) in
            //print(result)
            if let sinsCommitted = result["results"] as? [String] {
                //print(sinsCommited)
                completionHandlerForSinsCommited(results: sinsCommitted, errorString: nil);
            }
        }
    }
    
    func getPassage(){
        
        let parameters = [
            "id": 1,
            ]
        
        taskForGETMethod(ISINClient.API.BIBLEORG, method: "", parameters: parameters) { (result, error) -> Void in
            print("request result:");
            
            if let res = result as? [[String:AnyObject]] {
                var newPassage = ISINPassage(dictionaryArray: res)
                //completionHandlerForSinsCommited();
                //print(newPassage)
            }
            
            /*
             var resultVerse = ""
             
             if let resArray = result as? [[String:AnyObject]] {
             
             for(var i=0; i < resArray.count; i++){
             print("printing record: ", i)
             print(resArray[i])
             var tempRes = resArray[i]
             
             if let resText = tempRes["text"] as? String {
             print(resText)
             }
             }
             }
             */
        }
    }
}

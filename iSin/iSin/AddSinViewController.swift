//
//  AddSinViewController.swift
//  iSin
//
//  Created by Kinan Turman on 3/22/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation

class AddSinViewController:UIViewController {

    override func viewDidLoad() {
        
        let parameters = [
            "passage":"Numbers 15:39",
            "type":"json"
        ]
        
        ISINClient.sharedInstance().taskForGETMethod("", parameters: parameters) { (result, error) -> Void in
            print("request result:");
            
            if let res = result as? [[String:AnyObject]] {
                var newPassage = ISINPassage(dictionaryArray: res)
                print(newPassage)
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
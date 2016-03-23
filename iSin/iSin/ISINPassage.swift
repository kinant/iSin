//
//  ISINPassage.swift
//  iSin
//
//  Created by Kinan Turman on 3/22/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation

class ISINPassage : CustomStringConvertible {
    
    var book:String!
    var chapter:Int!
    var start:Int!
    var end:Int!
    var text:String!
    
    init(dictionaryArray: [[String:AnyObject]]){
        
        if let temp_book = dictionaryArray[0]["bookname"] as? String {
            self.book = temp_book
        }
        
        if let temp_chapter = dictionaryArray[0]["chapter"]as? String {
            self.chapter = Int(temp_chapter)
        }
        
        if let temp_start = dictionaryArray[0]["verse"] as? String {
            self.start = Int(temp_start)
        }
        
        if dictionaryArray.count > 1 {
            if let temp_end = dictionaryArray[dictionaryArray.count-1]["verse"] as? String {
                self.end = Int(temp_end)
            }
        } else {
            self.end = 0;
        }
        
        self.text = ""
        
        for(var i=0; i<dictionaryArray.count;i++){
            if let temp_text = dictionaryArray[i]["text"] as? String {
                self.text = self.text + temp_text
            }
        }
    }
    
    var description: String {
        return "\(title), \(text)"
    }
    
    var title : String {
        
        if self.end != 0 {
            return "\(book) \(chapter):\(start)-\(end)"
        } else {
            return "\(book) \(chapter):\(start)"
        }
    }
}
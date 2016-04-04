//
//  ISINPassage.swift
//  iSin
//
//  Created by Kinan Turman on 3/22/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

import Foundation
import CoreData

class Passage : NSManagedObject {
    
    @NSManaged var book:String
    @NSManaged var chapter: NSNumber
    @NSManaged var start: NSNumber
    @NSManaged var end: NSNumber
    @NSManaged var text:String
    @NSManaged var sin_type: NSNumber
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [[String:AnyObject]]?, dataArray:[String: AnyObject]?, sinID: Int, context: NSManagedObjectContext){
        
        let entity =  NSEntityDescription.entityForName("Passage", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        if dictionary != nil {
            if let temp_book = dictionary![0]["bookname"] as? String {
                self.book = temp_book
            }
            
            if let temp_chapter = dictionary![0]["chapter"]as? String {
                self.chapter = Int(temp_chapter)!
            }
            
            if let temp_start = dictionary![0]["verse"] as? String {
                self.start = Int(temp_start)!
            }
            
            if dictionary!.count > 1 {
                if let temp_end = dictionary![dictionary!.count-1]["verse"] as? String {
                    self.end = Int(temp_end)!
                }
            } else {
                self.end = 0;
            }
            
            self.text = ""
            
            for i in 0 ..< dictionary!.count {
                if let temp_text = dictionary![i]["text"] as? String {
                    self.text = self.text + temp_text
                }
            }
        } else if dataArray != nil {
        
            if let temp_book = dataArray!["book"] as? String {
                self.book = temp_book
            }
        
            if let temp_chapter = dataArray!["chapter"] as? Int {
                self.chapter = temp_chapter
            }
        
            if let temp_start = dataArray!["verse_start"] as? Int {
                self.start = temp_start
            }
        
            if let temp_end = dataArray!["verse_end"] as? Int {
                self.end = temp_end
            }
        
            self.text = ""
        }
        
        self.sin_type = sinID
        
    }
    
    override var description: String {
        return "\(title), \(text)"
    }
    
    var title : String {
        
        if self.end != 0 {
            return "\(book) \(chapter):\(start)-\(end)"
        } else {
            return "\(book) \(chapter):\(start)"
        }
    }
    
    var searchParameter : String {
        if self.end != 0 {
            return "\(book)\(chapter):\(start)-\(end)"
        } else {
            return "\(book)\(chapter):\(start)"
        }
    }
}
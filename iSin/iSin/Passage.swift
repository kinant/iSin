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
    
    // properties
    @NSManaged var book:String
    @NSManaged var chapter: NSNumber
    @NSManaged var start: NSNumber
    @NSManaged var end: NSNumber
    @NSManaged var text:String
    @NSManaged var sin_type: NSNumber
    @NSManaged var isCustom: Bool
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [[String:AnyObject]]?, dataArray:[String: AnyObject]?, sinID: Int, entityName:String, context: NSManagedObjectContext){
        
        /* The initializer can either take a dictionary array (from bible org) or a data
            array, from iSIN API, to build a passage.
         */
        
        let entity =  NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // build passage from iSIN API
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
        
            // build passage from Bible Org API
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
        
        // set the sinID and the isCustom flag to false
        self.sin_type = sinID
        self.isCustom = false
    }
    
    // this is for using the print() function
    override var description: String {
        return "\(title), \(text)"
    }
    
    // returns the title of the Passage (Book Chapter:VerseStart-VerseEnd)
    var title : String {
        
        if self.end != 0 {
            return "\(book) \(chapter):\(start)-\(end)"
        } else {
            return "\(book) \(chapter):\(start)"
        }
    }
    
    // returns the search term to search for this passage in bible org API
    var searchParameter : String {
        if self.end != 0 {
            return "\(book)\(chapter):\(start)-\(end)"
        } else {
            return "\(book)\(chapter):\(start)"
        }
    }
}
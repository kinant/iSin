//
//  Constants.swift
//  iSin
//
//  Created by Kinan Turman on 3/22/16.
//  Copyright © 2016 Kinan Turman. All rights reserved.
//

extension ISINClient {
    
    enum API {
        case ISIN, BIBLEORG
    }
    
    // MARK: Constants
    struct ISINConstants {
        // MARK: iSin API URLs
        static let ApiScheme = "http"
        static let ApiHost = "kturman.com"
        static let ApiPath = "/api/"
    }
    
    struct BIBLEORGConstants {
        // MARK: Bible Org API URLs
        static let ApiScheme = "http"
        static let ApiHost = "labs.bible.org"
        static let ApiPath = "/api/"
    }
    
    struct EntityNames {
        // MARK: CoreData Entity names
        static let ListSin = "Sin"
        static let ListPassage = "Passage"
        static let RecordSin = "RecordSin"
        static let RecordPassage = "RecordPassage"
    }
    
    struct SinIndexes {
        // MARK: Internal indexes for the sins
        static let Lust = 1
        static let Gluttony = 2
        static let Greed = 3
        static let Sloth = 4
        static let Wrath = 5
        static let Envy = 6
        static let Pride = 7
    }
}

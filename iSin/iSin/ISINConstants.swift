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
        // MARK: URLs
        static let ApiScheme = "http"
        static let ApiHost = "kturman.com"
        static let ApiPath = "/api/"
    }
    
    // MARK: Constants
    struct BIBLEORGConstants {
        // MARK: URLs
        static let ApiScheme = "http"
        static let ApiHost = "labs.bible.org"
        static let ApiPath = "/api/"
    }
    
    struct EntityNames {
        static let ListSin = "Sin"
        static let ListPassage = "Passage"
        static let RecordSin = "RecordSin"
        static let RecordPassage = "RecordPassage"
    }
}

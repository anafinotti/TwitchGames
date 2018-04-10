//
//  TopGames.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/9/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit
import ObjectMapper

class TopGames: NSObject, NSCoding, Mappable {
    
    var total: Int?
    var top: [Top]?

    override init() { }
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    // Mappable
    func mapping(map: Map) {
        total   <- map["_total"]
        top     <- map["top"]
    }
    
    //MARK: Coding
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.total = aDecoder.decodeObject(forKey: "_total") as? Int
        self.top = aDecoder.decodeObject(forKey: "top") as? [Top]
    }
    
    func encode(with aCoder: NSCoder) {
        if let total = total { aCoder.encode(total, forKey: "_total")}
        if let top = top { aCoder.encode(top, forKey: "top")}
    }
}

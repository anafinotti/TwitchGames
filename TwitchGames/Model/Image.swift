//
//  Image.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/9/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit
import ObjectMapper

class Image: NSObject, NSCoding, Mappable {
    
    var standard: String?
    
    override init() { }
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    // Mappable
    func mapping(map: Map) {
        standard      <- map["standard"]
    }
    
    //MARK: Coding
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.standard = aDecoder.decodeObject(forKey: "standard") as? String
        
    }
    
    func encode(with aCoder: NSCoder) {
        if let standard = standard { aCoder.encode(standard, forKey: "standard")}
    }
}

//
//  ProductPrice.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/15/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit
import ObjectMapper

class ProductPrice: NSObject, NSCoding, Mappable {
    
    var current: String?
    
    override init() { }
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    // Mappable
    func mapping(map: Map) {
        current      <- map["current"]
    }
    
    //MARK: Coding
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.current = aDecoder.decodeObject(forKey: "current") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        if let current = current { aCoder.encode(current, forKey: "current")}
    }
}
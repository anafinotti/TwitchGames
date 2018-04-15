//
//  ProductName.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/15/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit
import ObjectMapper

class ProductName: NSObject, NSCoding, Mappable {
    
    var title: String?
    
    override init() { }
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    // Mappable
    func mapping(map: Map) {
        title      <- map["title"]
    }
    
    //MARK: Coding
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        
    }
    
    func encode(with aCoder: NSCoder) {
        if let title = title { aCoder.encode(title, forKey: "title")}
    }
}

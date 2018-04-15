//
//  Product.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/15/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit

import ObjectMapper

class Product: NSObject, NSCoding, Mappable {
    
    var sku: Int?
    var name: String?
    var image: String?
    
    override init() { }
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    // Mappable
    func mapping(map: Map) {
        sku         <- map["sku"]
        name        <- map["name"]
        image       <- map["image"]
    }
    
    //MARK: Coding
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.sku = aDecoder.decodeObject(forKey: "sku") as? Int
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.image = aDecoder.decodeObject(forKey: "image") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        if let sku = sku { aCoder.encode(sku, forKey: "sku")}
        if let name = name { aCoder.encode(name, forKey: "name")}
        if let image = image { aCoder.encode(image, forKey: "image")}
    }
}

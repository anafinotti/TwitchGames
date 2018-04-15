//
//  ProductList.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/15/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit
import ObjectMapper

class ProductList: NSObject, NSCoding, Mappable {
    
    var products: [Product]?
    
    override init() { }
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    // Mappable
    func mapping(map: Map) {
        products      <- map["products"]
    }
    
    //MARK: Coding
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.products = aDecoder.decodeObject(forKey: "products") as? [Product]
    }
    
    func encode(with aCoder: NSCoder) {
        if let products = products { aCoder.encode(products, forKey: "products")}
    }
}

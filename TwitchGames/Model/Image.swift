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
    
    var large: String?
    var medium: String?
    var small: String?
    var template: String?
    
    override init() { }
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    // Mappable
    func mapping(map: Map) {
        large      <- map["large"]
        medium     <- map["medium"]
        small      <- map["small"]
        template   <- map["template"]
    }
    
    //MARK: Coding
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.large = aDecoder.decodeObject(forKey: "large") as? String
        self.medium = aDecoder.decodeObject(forKey: "medium") as? String
        self.small = aDecoder.decodeObject(forKey: "small") as? String
        self.template = aDecoder.decodeObject(forKey: "template") as? String
        
    }
    
    func encode(with aCoder: NSCoder) {
        if let large = large { aCoder.encode(large, forKey: "large")}
        if let medium = medium { aCoder.encode(medium, forKey: "medium")}
        if let small = small { aCoder.encode(small, forKey: "small")}
        if let template = template { aCoder.encode(template, forKey: "template")}
    }
}

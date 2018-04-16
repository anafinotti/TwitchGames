//
//  Product.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/15/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit
import CoreData
import CoreDataManager

import ObjectMapper

class Product: NSManagedObject, NSCoding, Mappable {
    @NSManaged var sku: NSNumber?
    @NSManaged var name: String?
    @NSManaged var image: String?
    @NSManaged var isFavorite: NSNumber!

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    required init?(map: Map) {
        let context = CoreDataManager.sharedInstance.mainContext
        let entity = NSEntityDescription.entity(forEntityName: "Product", in: context)
        super.init(entity: entity!, insertInto: context)
        mapping(map: map)
    }
    
    // Mappable
    func mapping(map: Map) {
        sku         <- map["sku"]
        name        <- map["name"]
        image       <- map["image"]
        isFavorite  = false
    }
    
    //MARK: Coding
    required init?(coder aDecoder: NSCoder) {
        let context = CoreDataManager.sharedInstance.mainContext
        let entity = NSEntityDescription.entity(forEntityName: "Product", in: context)
        super.init(entity: entity!, insertInto: context)
        self.sku = aDecoder.decodeObject(forKey: "sku") as? NSNumber
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.image = aDecoder.decodeObject(forKey: "image") as? String
        self.isFavorite = aDecoder.decodeObject(forKey: "isFavorite") as? NSNumber
    }
    
    func encode(with aCoder: NSCoder) {
        if let sku = sku { aCoder.encode(sku, forKey: "sku")}
        if let name = name { aCoder.encode(name, forKey: "name")}
        if let image = image { aCoder.encode(image, forKey: "image")}
        if let isFavorite = isFavorite { aCoder.encode(isFavorite, forKey: "isFavorite")}
    }
}

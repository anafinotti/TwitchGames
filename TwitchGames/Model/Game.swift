//
//  Game.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/7/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit
import ObjectMapper

class Game: NSObject, NSCoding, Mappable {

    var id: Int?
    var box: Image?
    var giantbombId: Int?
    var logo: Image?
    var name: String?
    var popularity: Int?
    
    override init() { }
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    // Mappable
    func mapping(map: Map) {
        id              <- map["_id"]
        box             <- map["box"]
        giantbombId     <- map["giantbomb_id"]
        logo            <- map["logo"]
        name            <- map["name"]
        popularity      <- map["popularity"]
    }
    
    //MARK: Coding
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeObject(forKey: "_id") as? Int
        self.box = aDecoder.decodeObject(forKey: "box") as? Image
        self.giantbombId = aDecoder.decodeObject(forKey: "giantbomb_id") as? Int
        self.logo = aDecoder.decodeObject(forKey: "logo") as? Image
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.popularity = aDecoder.decodeObject(forKey: "popularity") as? Int

    }
    
    func encode(with aCoder: NSCoder) {
        if let id = id { aCoder.encode(id, forKey: "_id")}
        if let box = box { aCoder.encode(box, forKey: "box")}
        if let giantbombId = giantbombId { aCoder.encode(giantbombId, forKey: "giantbomb_id")}
        if let logo = logo { aCoder.encode(logo, forKey: "logo")}
        if let name = name { aCoder.encode(name, forKey: "name")}
        if let popularity = popularity { aCoder.encode(popularity, forKey: "popularity")}
    }
}

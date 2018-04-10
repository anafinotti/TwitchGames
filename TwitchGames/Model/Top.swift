//
//  Top.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/9/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit
import ObjectMapper

class Top: NSObject, NSCoding, Mappable {
    
    var channels: Int?
    var viewers: Int?
    var game: Game?
    
    override init() { }
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    // Mappable
    func mapping(map: Map) {
        channels    <- map["channels"]
        viewers     <- map["viewers"]
        game        <- map["game"]
    }
    
    //MARK: Coding
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.channels = aDecoder.decodeObject(forKey: "channels") as? Int
        self.viewers = aDecoder.decodeObject(forKey: "viewers") as? Int
        self.game = aDecoder.decodeObject(forKey: "game") as? Game
    }
    
    func encode(with aCoder: NSCoder) {
        if let channels = channels { aCoder.encode(channels, forKey: "channels")}
        if let viewers = viewers { aCoder.encode(viewers, forKey: " viewers")}
        if let game = game { aCoder.encode(game, forKey: "game")}
    }
}

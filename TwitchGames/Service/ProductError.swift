//
//  ProductError.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/9/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit

protocol ProductErrorProtocol: Error {
    var name: String { get }
    var id: Int { get }
}

struct ProductError: ProductErrorProtocol {
    var name: String
    var id: Int
    
    init(name: String?, id: Int) {
        self.name = name ?? "Error"
        self.id = id
    }
}

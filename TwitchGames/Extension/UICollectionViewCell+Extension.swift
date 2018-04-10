//
//  UICollectionViewCell+Extension.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/9/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    class func cellReuseIdentifier() -> String {
        return String(describing: self)
    }
}

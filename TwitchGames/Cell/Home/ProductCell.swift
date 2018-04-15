//
//  ProductCell.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/9/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {

    @IBOutlet var favoriteImageView: UIImageView!
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var productNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupProductCell(product: Product) {
        productNameLabel.text = product.name
        if let image = product.image {
            productImageView.downloadedFrom(link: image, contentMode: .scaleAspectFit)
        } else {
            productImageView.image = UIImage(named: "default-placeholder")
        }
    }
}

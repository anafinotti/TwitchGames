//
//  DetailPresenter.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/16/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit
import CoreData
import CoreDataManager

protocol DetailView: class {
    func showAlert(name: String)
}

class DetailPresenter {
    private let cdm = CoreDataManager.sharedInstance
    weak private var detailView: DetailView?
    
    // MARK: Initialization
    init() {
    }
    
    func attachView(view: DetailView?) {
        guard let view = view else { return }
        detailView = view
    }
    
    func setFavoritesToCoreData(product: Product) {
        let context = self.cdm.backgroundContext
        context.perform {
            let context = self.cdm.backgroundContext
            if let p = context.managerFor(Product.self).filter(format: "sku = %@", product.sku!).first {
                p.delete()
                self.detailView?.showAlert(name: "Produto desfavoritado")
            } else {
                let newProduct = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context) as! Product
                newProduct.name = product.name
                newProduct.sku = product.sku
                newProduct.image = product.image
                newProduct.isFavorite = product.isFavorite
                self.detailView?.showAlert(name: "Produto favoritado")
            }
            try! context.save()
        }
    }
}


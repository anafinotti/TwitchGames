//
//  FavoritePresenter.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/16/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit
import CoreData
import CoreDataManager

protocol FavoriteView: class {
    func startLoading()
    func finishLoading()
    func setFavorites(favorites: [Product])
    func showAlert(name: String)
    func dismissSearchControllerIfExists()
}

class FavoritePresenter {
    
    private let cdm = CoreDataManager.sharedInstance
    weak private var favoriteView: FavoriteView?
    
    // MARK: Initialization
    init() {
    }
    
    func attachView(view: FavoriteView?) {
        guard let view = view else { return }
        favoriteView = view
    }
    
    func removeFavoriteFromCoreData(product: Product) {
        let context = self.cdm.backgroundContext
        context.perform {
            let context = self.cdm.backgroundContext
            if let p = context.managerFor(Product.self).filter(format: "sku = %@", product.sku!).first {
                p.delete()
            }
            try! context.saveIfChanged()
            self.favoriteView?.showAlert(name: "Produto desfavoritado")
        }
    }
    
    func getFavorites(limit: Int) {
        let fetchRequest = NSFetchRequest<Product>(entityName: "Product")
        fetchRequest.fetchLimit = limit

        let sortDescriptor = NSSortDescriptor(key: "sku", ascending: false)

        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "isFavorite == YES")
        let aFetchedResultsController = NSFetchedResultsController<Product>(fetchRequest: fetchRequest, managedObjectContext: self.cdm.backgroundContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try! aFetchedResultsController.performFetch()
        }
        let favorites: [Product] = aFetchedResultsController.fetchedObjects!
        favoriteView?.setFavorites(favorites: favorites)
    }
    
    
}

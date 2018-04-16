//
//  HomePresenter.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/6/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit
import CoreData
import CoreDataManager

protocol HomeView: class {
    func startLoading()
    func finishLoading()
    func setProducts(productList: ProductList)
    func setFavorites(favorites: [Product])
    func showAlert(name: String)
    func dismissSearchControllerIfExists()
}

class HomePresenter {
    
    private let cdm = CoreDataManager.sharedInstance
    let homeService: HomeService
    weak private var homeView: HomeView?
    private var favorites = [Product]()
    
    // MARK: Initialization
    init(homeService: HomeService) {
        self.homeService = homeService
    }
    
    func attachView(view: HomeView?) {
        guard let view = view else { return }
        homeView = view
    }
    
    //MARK: Core Data
    func getFavorites() {
        let context = cdm.mainContext
        favorites = context.managerFor(Product.self).array
    }
    
    func setFavoritesToCoreData(product: Product) {
        let context = self.cdm.backgroundContext
        context.perform {
            let context = self.cdm.backgroundContext
            if let p = context.managerFor(Product.self).filter(format: "sku = %@", product.sku!).first {
                p.delete()
            }
            let newProduct = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context) as! Product
            newProduct.name = product.name
            newProduct.sku = product.sku
            newProduct.image = product.image
            newProduct.isFavorite = product.isFavorite
            try! context.saveIfChanged()
            self.homeView?.showAlert(name: newProduct.isFavorite.boolValue ? "Produto favoritado" : "Produto desfavoritado")
            
        }
    }
    
    // MARK: Service
    func getProducts(page: Int) {
        self.homeView?.startLoading()
        
        let parameters = ["show": "sku,name,image",
                          "pageSize": "20",
                          "page": String(page),
                          "apiKey": "WN9pMo0Qd9KFUPfCN6QqAYZi",
                          "format": "json"] as [String : Any]
        
        homeService.getProducts(parameters: parameters, result: { [weak self] productList in
            guard let `self` = self else { return }
            self.homeView?.finishLoading()
            
            guard productList.products != nil else {
                self.homeView?.showAlert(name: "Nenhum produto encontrado")
                return
            }
            self.homeView?.setProducts(productList: productList)
            self.homeView?.setFavorites(favorites: self.favorites)
            
        }) { [weak self] (error) in
            
            guard let `self` = self else { return }
            
            self.homeView?.finishLoading()
            self.homeView?.dismissSearchControllerIfExists()
            self.homeView?.showAlert(name: error.name)
        }
    }
}

//
//  HomePresenter.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/6/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit

protocol HomeView: class {
    func startLoading()
    func finishLoading()
    func setProducts(productList: ProductList)
    func showAlert(name: String)
    func dismissSearchControllerIfExists()
}

class HomePresenter {
    
    let homeService: HomeService
    weak private var homeView: HomeView?
    
    // MARK: Initialization
    init(homeService: HomeService) {
        self.homeService = homeService
    }
    
    func attachView(view: HomeView?) {
        guard let view = view else { return }
        homeView = view
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

        }) { [weak self] (error) in
            
            guard let `self` = self else { return }
            
            self.homeView?.finishLoading()
            self.homeView?.dismissSearchControllerIfExists()
            self.homeView?.showAlert(name: error.name)
        }
    }
}

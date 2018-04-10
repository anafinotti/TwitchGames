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
    func setTopGames(topGames: TopGames)
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
    func getTopGames() {
        self.homeView?.startLoading()
        
        homeService.getTopGames(result: { [weak self] topGames in
            guard let `self` = self else { return }
            self.homeView?.finishLoading()
            
            guard topGames.top?.count != 0 else {
                self.homeView?.showAlert(name: "No result found")
                return
            }
            self.homeView?.setTopGames(topGames: topGames)

        }) { [weak self] (error) in
            
            guard let `self` = self else { return }
            
            self.homeView?.finishLoading()
            self.homeView?.dismissSearchControllerIfExists()
            self.homeView?.showAlert(name: error.name)
        }
    }
}

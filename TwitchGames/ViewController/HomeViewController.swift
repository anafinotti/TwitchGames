//
//  HomeViewController.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/6/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var collectionView: UICollectionView!

    let homePresenter = HomePresenter(homeService: HomeService())
    fileprivate var topGames = TopGames()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        homePresenter.attachView(view: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: CollectionView Delegate/Datasource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.cellReuseIdentifier(), for: indexPath) as! GameCell

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension HomeViewController: HomeView {
    
    func startLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func finishLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        //refreshControl?.endRefreshing()
    }
    
    func setTopGames(topGames: TopGames) {
        self.topGames = topGames
        
        dismissSearchControllerIfExists()
        //self.tableView.reloadData()
    }

    func showAlert(name: String) {
        let controller = UIAlertController(title: name, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .default, handler: nil)
        controller.addAction(action)
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    func dismissSearchControllerIfExists() {
//        if isSearching {
//            isSearching = false
//            self.searchController.searchBar.resignFirstResponder()
//            searchController.dismiss(animated: true, completion: nil)
//            self.searchController.searchBar.text = ""
//            self.tableView.reloadData()
//        }
    }
}

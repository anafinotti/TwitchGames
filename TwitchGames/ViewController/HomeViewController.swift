//
//  HomeViewController.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/6/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit
import CoreData
import CoreDataManager

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    private let cdm = CoreDataManager.sharedInstance
    
    private var productCell = "ProductCell"
    let homePresenter = HomePresenter(homeService: HomeService())
    fileprivate var productList = ProductList()
    var isSearching = false
    
    private var refreshControl: UIRefreshControl?
    private var page = 1
    private var favorites = [Product]()
    private var searchActive = false
    private var filteredArray = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        setupCollectionView()
        homePresenter.getProducts(page: page)
        homePresenter.getFavorites()
    }
    
    //MARK: Setup CollectionView
    func setupCollectionView() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.register(UINib(nibName: productCell, bundle: nil), forCellWithReuseIdentifier: productCell)
        collectionView.isPagingEnabled = true
        homePresenter.attachView(view: self)
        isSearching = true
    }
    
    //MARK: Core Data
    @objc func saveFavoriteToCoreData(sender: UITapGestureRecognizer) {
        if let view = sender.view {
            let tag = view.tag
            if let products = productList.products {
                let product = products[tag]
                product.isFavorite = product.isFavorite == 1 ? 0 : 1
                collectionView.reloadItems(at: [IndexPath(item: tag, section: 0)])
                homePresenter.setFavoritesToCoreData(product: product)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: CollectionView Delegate/Datasource
    @objc func refreshData() {
        productList = ProductList()
        page = 1
        homePresenter.getProducts(page: page)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return 0
        } else if searchActive {
            return filteredArray.count
        }
        return (productList.products?.count)!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.cellReuseIdentifier(), for: indexPath) as! ProductCell
        if searchActive {
            let product = filteredArray[indexPath.row]
            cell.favoriteImageView.tag = indexPath.row
            cell.favoriteImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveFavoriteToCoreData(sender:))))
            cell.setupProductCell(product: product, isFavorite: product.isFavorite!.boolValue)
          
        } else {
            if let product = productList.products?[indexPath.row] {
                cell.favoriteImageView.tag = indexPath.row
                cell.favoriteImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveFavoriteToCoreData(sender:))))
                cell.setupProductCell(product: product, isFavorite: product.isFavorite!.boolValue)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if let products = productList.products {
            if indexPath.row + 1 == products.count {
                page += 1
                isSearching = true
                homePresenter.getProducts(page: page)
            }
        }
    }
    //MARK: - SEARCH
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(!(searchBar.text?.isEmpty)!){
            self.collectionView?.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchActive = true
        if(!searchText.isEmpty){
            if let products = productList.products {
                filteredArray = products.filter({ ($0.name?.contains(searchText))! })
            }
            self.collectionView?.reloadData()
        }
    }
}

extension HomeViewController: HomeView {
    
    func startLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func finishLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func setFavorites(favorites: [Product]) {
        if favorites.count > 0 {
            favorites.forEach { (favorite) in
                if let product = productList.products?.filter({ $0.sku == favorite.sku }).first {
                    product.isFavorite = favorite.isFavorite
                }
            }
        }
    }
    
    func setProducts(productList: ProductList) {
        refreshControl?.endRefreshing()
        if self.productList.products == nil {
            self.productList = productList
        } else {
            self.productList.products = self.productList.products! + productList.products!
        }
        
        if self.productList.products == nil {
            showAlert(name: "Nenhum produto encontrado")
        } else {
            dismissSearchControllerIfExists()
            collectionView.reloadData()
        }
    }
    
    func showAlert(name: String) {
        let controller = UIAlertController(title: name, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .default, handler: nil)
        controller.addAction(action)
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    func dismissSearchControllerIfExists() {
        if isSearching {
            isSearching = false
        }
    }
}

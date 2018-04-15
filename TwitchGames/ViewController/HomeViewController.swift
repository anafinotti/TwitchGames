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


    private var productCell = "ProductCell"
    let homePresenter = HomePresenter(homeService: HomeService())
    fileprivate var productList = ProductList()
    var isSearching = false
    
    private var refreshControl: UIRefreshControl?
    private var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        setupCollectionView()
        homePresenter.getProducts(page: page)
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
    
    @objc func refreshData() {
        productList = ProductList()
        page = 1
        homePresenter.getProducts(page: page)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: CollectionView Delegate/Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return 0
        } else {
            return (productList.products?.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.cellReuseIdentifier(), for: indexPath) as! ProductCell
        if let product = productList.products?[indexPath.row] {
            cell.setupProductCell(product: product)
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
                homePresenter.getProducts(page: page)
            }
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

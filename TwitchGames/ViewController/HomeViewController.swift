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

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet var collectionView: UICollectionView!

    private let cdm = CoreDataManager.sharedInstance

    private var productCell = "ProductCell"
    let homePresenter = HomePresenter(homeService: HomeService())
    fileprivate var productList = ProductList()
    var isSearching = false
    
    private var refreshControl: UIRefreshControl?
    private var page = 1
    private var favoriteTag: Int?
    private var favoriteProducts = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        setupCollectionView()
        homePresenter.getProducts(page: page)
        getFavoriteProducts()
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
        if let favoriteImageView = sender.view as? UIImageView {
            favoriteTag = favoriteImageView.tag
            if let products = productList.products {
                let product = products[favoriteTag!]
                product.isFavorite = product.isFavorite == 1 ? 0 : 1
                self.collectionView.reloadItems(at: [IndexPath(item: favoriteTag!, section: 0)])
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
                    self.showAlert(name: newProduct.isFavorite.boolValue ? "Produto favoritado" : "Produto desfavoritado")
                
                }
            }
        }
    }
    
    func getFavoriteProducts() {
        let context = self.cdm.mainContext

        let favoriteProducts = context.managerFor(Product.self).array
        self.favoriteProducts = favoriteProducts
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
        } else {
            return (productList.products?.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.cellReuseIdentifier(), for: indexPath) as! ProductCell
        if let product = productList.products?[indexPath.row] {
            cell.favoriteImageView.tag = indexPath.row
            cell.favoriteImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveFavoriteToCoreData(sender:))))
            cell.setupProductCell(product: product, isFavorite: product.isFavorite!.boolValue)
//            if favoriteProducts.count > 0 {
//                if let favoriteProduct = favoriteProducts.filter({ $0.sku == product.sku }).first {
//                    cell.setupProductCell(product: product, isFavorite: favoriteProduct.isFavorite!.boolValue)
//                }
//            }
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

            favoriteProducts.forEach { (product) in
                if let favorite = productList.products?.filter({ $0.sku == product.sku }).first {
                    favorite.isFavorite = product.isFavorite
                }
            }
            isSearching = false
        }
    }
}

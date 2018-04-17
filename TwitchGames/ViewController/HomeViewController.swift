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
import MobileCoreServices

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDragDelegate, UICollectionViewDropDelegate, UISearchControllerDelegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate, UIDropInteractionDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    private let cdm = CoreDataManager.sharedInstance
    
    private var productCell = "ProductCell"
    let homePresenter = HomePresenter(homeService: HomeService())
    fileprivate var productList = ProductList()
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    var isSearching = false
    var searchController: UISearchController?
    private var refreshControl: UIRefreshControl?
    private var page = 1
    private var favorites = [Product]()
    private var searchActive = false
    private var filteredArray = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        searchController?.delegate = self
        searchController?.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        searchController?.searchBar.becomeFirstResponder()
        
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
        homePresenter.attachView(view: self)
        isSearching = true
    }
    
    //MARK: Gesture Recognizer
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
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
        isSearching = true
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
        let dropInteraction = UIDropInteraction(delegate: self)

        cell.addInteraction(dropInteraction)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var selectedProduct: Product?
        if searchActive {
            selectedProduct = filteredArray[indexPath.row]
        } else {
            selectedProduct = productList.products?[indexPath.row]
        }
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        detailViewController?.product = selectedProduct
        navigationController?.pushViewController(detailViewController!, animated: true)
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
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print(sourceIndexPath.item)
        print(destinationIndexPath.item)
    }
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        var selectedProduct: Product?
        if searchActive {
            selectedProduct = filteredArray[indexPath.row]
        } else {
            selectedProduct = productList.products?[indexPath.row]
        }
        let itemProvider = NSItemProvider(object: selectedProduct?.name as! NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = selectedProduct
        return [dragItem]
    }

    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    }
    
    //MARK: Drop Interaction Delegate
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return true
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: UIDropOperation.move)
    }
    
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        let ffi = session.items[0].localObject as! Product
        // Necessary logic to parse the NSManagedObject
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, concludeDrop session: UIDropSession) {
        
    }

    //MARK: - SEARCH
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(!(searchBar.text?.isEmpty)!){
            self.collectionView?.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
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
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if !searchActive {
            searchActive = true
            collectionView.reloadData()
        }
        
        searchController?.searchBar.resignFirstResponder()
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
        productList.products?.forEach({ (filter) in
            filter.isFavorite = 0
        })
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

extension UITabBarController: UIDropInteractionDelegate {
    
}

//
//  FavoriteViewController.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/6/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit
import CoreData
import CoreDataManager

class FavoriteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    private let cdm = CoreDataManager.sharedInstance
    
    private var productCell = "ProductCell"
    let favoritePresenter = FavoritePresenter()
    fileprivate var favorites = [Product]()
    var isSearching = false
    
    private var refreshControl: UIRefreshControl?
    private var pageSize = 20
    private var searchActive = false
    private var filteredArray = [Product]()
    var searchController: UISearchController?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        favoritePresenter.attachView(view: self)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_favorite_disabled"), style: .plain, target: self, action: nil)

        setupCollectionView()
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        favoritePresenter.getFavorites(limit: pageSize)
    }
    
    //MARK: Setup CollectionView
    func setupCollectionView() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.register(UINib(nibName: productCell, bundle: nil), forCellWithReuseIdentifier: productCell)
        collectionView.isPagingEnabled = true
        isSearching = true
    }
    
    //MARK: Core Data
    @objc func removeFavoriteFromCoreData(sender: UITapGestureRecognizer) {
        if let view = sender.view {
            let tag = view.tag
            let favorite = favorites[tag]
            favorites.remove(at: tag)
            collectionView.reloadData()
            favoritePresenter.removeFavoriteFromCoreData(product: favorite)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: CollectionView Delegate/Datasource
    @objc func refreshData() {
        favorites = [Product]()
        pageSize = 20
        isSearching = true
        favoritePresenter.getFavorites(limit: pageSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return 0
        } else if searchActive {
            return filteredArray.count
        }
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.cellReuseIdentifier(), for: indexPath) as! ProductCell
        if searchActive {
            let product = filteredArray[indexPath.row]
            cell.favoriteImageView.tag = indexPath.row
            cell.favoriteImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeFavoriteFromCoreData(sender:))))
            cell.setupProductCell(product: product, isFavorite: product.isFavorite!.boolValue)
            
        } else {
            let favorite = favorites[indexPath.row]
            cell.favoriteImageView.tag = indexPath.row
            cell.favoriteImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeFavoriteFromCoreData(sender:))))
            cell.setupProductCell(product: favorite, isFavorite: favorite.isFavorite!.boolValue)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        detailViewController?.product = favorite
        navigationController?.pushViewController(detailViewController!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.row + 1 == pageSize {
            pageSize += 20
            collectionView.reloadData()
        }
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
            filteredArray = favorites.filter({ ($0.name?.contains(searchText))! })

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

extension FavoriteViewController: FavoriteView {
    
    func startLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func finishLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func setFavorites(favorites: [Product]) {
        refreshControl?.endRefreshing()
        isSearching = false
        self.favorites = favorites
        if self.favorites.count == 0 {
            showAlert(name: "Nenhum favorito encontrado")
        } else {
            dismissSearchControllerIfExists()
        }
        collectionView.reloadData()
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

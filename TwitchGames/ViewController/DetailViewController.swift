//
//  DetailViewController.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/6/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var product: Product?
    
    let detailPresenter = DetailPresenter()

    @IBOutlet var productIdLabel: UILabel!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var productImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailPresenter.attachView(view: self)

        setupView()
        
        var favoriteImage: UIImage?
        if (product?.isFavorite.boolValue)! {
            favoriteImage = UIImage(named: "favorite_enabled")
        } else {
            favoriteImage = UIImage(named: "favorite_disabled")
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: favoriteImage, style: .plain, target: self, action: #selector(favoriteButtonTapped))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: SetupView
    func setupView() {
        if let image = product?.image {
            productImageView.downloadedFrom(link: image, contentMode: .scaleAspectFit)
        } else {
            productImageView.image = UIImage(named: "default-placeholder")
        }
        
        productNameLabel.text = product?.name
        productIdLabel.text = "Cod: " + (product?.sku?.stringValue)!
    }
    
    //MARK: Actions
    @objc func favoriteButtonTapped() {
        var favoriteImage: UIImage?
        if !(product?.isFavorite.boolValue)! {
            product?.isFavorite = 1
            favoriteImage = UIImage(named: "favorite_enabled")
        } else {
            product?.isFavorite = 0
            favoriteImage = UIImage(named: "favorite_disabled")
        }
        navigationItem.rightBarButtonItem?.image = favoriteImage
        saveFavorite()
    }
    
    func saveFavorite() {
        detailPresenter.setFavoritesToCoreData(product: product!)
    }
}
extension DetailViewController: DetailView {
    func showAlert(name: String) {
        let controller = UIAlertController(title: name, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .default, handler: nil)
        controller.addAction(action)
        navigationController?.present(controller, animated: true, completion: nil)
    }
}

//
//  FavoriteService.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/16/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit

class FavoriteService {
    func getProducts(parameters: [String: Any], result: @escaping ((ProductList) -> Void),
                     failure: @escaping (errorHandler) = { _ in }) {
        ApiManager.getProducts(parameters: parameters, success: { productList in
            result(productList)
        }) { error in
            failure(error)
        }
    }
}

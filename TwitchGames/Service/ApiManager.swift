//
//  ApiManager.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/9/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

typealias errorHandler = (_ error: ProductError) -> ()

class ApiManager {
    
    class func getProducts(parameters: [String: Any], success: @escaping ((_ result: ProductList) -> ()),
                            failure: @escaping (errorHandler) = { _ in }) {

        Alamofire.request(RequestBuilder.getProducts(parameters)).responseObject { (response: DataResponse<ProductList>) in

            if let error = response.error {
                failure(ProductError(name: error.localizedDescription, id: error._code))
                return
            }

            guard let productList = response.result.value else {
                return
            }

            guard productList.products != nil else {
                failure(ProductError(name: "Nenhum producto encontrado", id: 101))
                return
            }

            success(productList)
        }
    }
    
}

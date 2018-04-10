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

typealias errorHandler = (_ error: TopGamesError) -> ()

class ApiManager {
    
    class func getTopGames(success: @escaping ((_ result: TopGames) -> ()),
                            failure: @escaping (errorHandler) = { _ in }) {
        Alamofire.request(RequestBuilder.getTopGames()).responseObject { (response: DataResponse<TopGames>) in
            
            if let error = response.error {
                failure(TopGamesError(name: error.localizedDescription, id: error._code))
                return
            }
            
            guard let topGames = response.result.value else {
                return
            }
            
            guard (topGames.top?.count)! > 0 else {
                failure(TopGamesError(name: "No data", id: 101))
                return
            }
        
            success(topGames)
        }
    }
    
}

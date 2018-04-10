//
//  HomeService.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/9/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit

class HomeService {
    func getTopGames(result: @escaping ((TopGames) -> Void),
                failure: @escaping (errorHandler) = { _ in }) {
        ApiManager.getTopGames(success: { topGames in
            result(topGames)
        }) { error in
            failure(error)
        }
    }
}

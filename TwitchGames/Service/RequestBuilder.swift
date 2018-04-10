//
//  RequestBuilder.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/9/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit
import Alamofire

enum RequestBuilder: URLRequestConvertible {
    
    case getTopGames()
    
    func asURLRequest() throws -> URLRequest {
        
        var method: HTTPMethod {
            switch self {
            case .getTopGames():
                return .get
            }
        }
        
        let url:URL = {
            let relativePath: String?
            
            switch self {
            case .getTopGames():
                relativePath = TGUrlHelper.base_Url + "games/top"
            }
            
            var urlString = TGUrlHelper.base_Url
            if let relativePath = relativePath {
                urlString.append(relativePath)
            }
            return URL(string: urlString)!
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        let encoding = JSONEncoding.default
        return try encoding.encode(urlRequest)
    }
    
}

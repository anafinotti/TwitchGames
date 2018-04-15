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
    
    case getProducts([String: Any])
    
    func asURLRequest() throws -> URLRequest {
        
        var method: HTTPMethod {
            switch self {
            case .getProducts(_):
                return .get
            }
        }
        
        var dictionary: [String: Any]!
        let url:URL = {
            let relativePath: String?
            
            switch self {
            case .getProducts(let parameters):
                dictionary = parameters
                relativePath = "products(type=Game)"
            }
            
            var urlString = TGUrlHelper.base_Url
            if let relativePath = relativePath {
                urlString.append(relativePath)
            }
            return URL(string: urlString)!
        }()
        var components = URLComponents(string: url.absoluteString)!
        components.queryItems = dictionary.map { (arg) -> URLQueryItem in
            let (key, value) = arg
            return URLQueryItem(name: key, value: value as? String)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        var urlRequest = URLRequest(url: components.url!)
        urlRequest.httpMethod = method.rawValue
        
      
        let encoding = JSONEncoding.default
        return try encoding.encode(urlRequest)
        
    }
    
}

//
//  TGUrlHelper.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/9/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit

class TGUrlHelper: NSObject {
    
    static let base_Url = TGUrlHelper.sharedInstance.stringURL(key: "Base_Url")
    
    static let sharedInstance = TGUrlHelper()
    
    private let serviceEnvironment = "Service Environment"
    
    private let serviceEnvironmentDevelopment = "isDevelopment"
    private let urlsPList = "urls"
    
    internal func stringURL(key: String) -> String {
        let environments = Bundle.main.object(forInfoDictionaryKey: serviceEnvironment)
        assert(environments != nil, "INVALID ENVIRONMENT: invalid plist (no \"Environments\" key!")
        if let dict = environments as? Dictionary<String, Any> {
            let development = dict[serviceEnvironmentDevelopment] as? Bool
            
            let anyNil = development == nil
            assert(!anyNil, "INVALID ENVIRONMENT: keys not found!")
            
            var plistName : String = "invalid-urls"
            if (development == true) { plistName = urlsPList }
            
            if let path = Bundle.main.path(forResource: plistName, ofType: "plist") {
                if let urlPlist = NSDictionary(contentsOfFile: path) {
                    return urlPlist[key] as! String
                }
            }
        }
        assert(false, "INVALID ENVIRONMENT: unknown error, url not found")
        return "invalidURL"
    }
    
    static func urlForKey(key: String) -> NSURL {
        return NSURL(string: key)!
    }
}

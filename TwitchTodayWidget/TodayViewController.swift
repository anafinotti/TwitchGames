//
//  TodayViewController.swift
//  TwitchTodayWidget
//
//  Created by Ana Finotti on 4/17/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var productOneImageView: UIImageView!
    @IBOutlet var productOneNameLabel: UILabel!
    @IBOutlet var productTwoImageView: UIImageView!
    @IBOutlet var productTwoNameLabel: UILabel!
    @IBOutlet var productThreeImageView: UIImageView!
    @IBOutlet var productThreeNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTodayWidget()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTodayWidget() {
        let userDefaults = UserDefaults.init(suiteName: "group.com.games")
        let arrayDict: [[String: String]] = userDefaults?.value(forKey: "products") as! [[String : String]]
        if arrayDict.count > 2 {
            let productOne = arrayDict.first
            productOneNameLabel.text = productOne?["name"]
            if productOne!["image"] != "" {
                productOneImageView.downloadedFrom(link: productOne!["image"]!, contentMode: .scaleAspectFit)
            } else {
                productOneImageView.image = UIImage(named: "default-placeholder")
            }
            let productTwo = arrayDict[1]
            productTwoNameLabel.text = productTwo["name"]
            
            if productTwo["image"] != "" {
                productTwoImageView.downloadedFrom(link: productTwo["image"]!, contentMode: .scaleAspectFit)
            } else {
                productTwoImageView.image = UIImage(named: "default-placeholder")
            }
            
            let productThree = arrayDict[2]
            productThreeNameLabel.text = productThree["name"]
            if productTwo["image"] != "" {
                productThreeImageView.downloadedFrom(link: productThree["image"]!, contentMode: .scaleAspectFit)
            } else {
                productThreeImageView.image = UIImage(named: "default-placeholder")
            }
        }
    }
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        let userDefaults = UserDefaults.init(suiteName: "group.com.games")
        let arrayDict: [[String: String]] = userDefaults?.value(forKey: "products") as! [[String : String]]
        if arrayDict.count > 2 {
            if arrayDict.first?["name"] != productOneNameLabel.text {
                setTodayWidget()
                completionHandler(NCUpdateResult.newData)
            } else {
                completionHandler(NCUpdateResult.noData)
            }
        } else {
            completionHandler(NCUpdateResult.newData)
        }
        
        completionHandler(NCUpdateResult.newData)
    }
}

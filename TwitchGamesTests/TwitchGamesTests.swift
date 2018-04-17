//
//  TwitchGamesTests.swift
//  TwitchGamesTests
//
//  Created by Ana Finotti on 4/6/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import XCTest
@testable import TwitchGames

class TwitchGamesTests: XCTestCase {
    
    var home: HomeViewController!
    var tabBarController: UITabBarController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        tabBarController = storyboard.instantiateInitialViewController() as! UITabBarController
        let navigationViewController = tabBarController.viewControllers?.first as! UINavigationController
        home = navigationViewController.viewControllers.first as! HomeViewController
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testProductsCount() {
        let parameters = ["show": "sku,name,image",
                          "pageSize": "5",
                          "page": "2",
                          "apiKey": "WN9pMo0Qd9KFUPfCN6QqAYZi",
                          "format": "json"] as [String : Any]
        testSearch(parameters: parameters, result: { (productList) in
            XCTAssertTrue(((productList.products?.count)! > 0), "Products count should be greater than zero")
        })
    }
    
    func testWithWrongApiKey() {
        let parameters = ["show": "sku,name,image",
                          "pageSize": "5",
                          "page": "1",
                          "apiKey": "23f2f23f32fwewef",
                          "format": "json"] as [String : Any]
        testSearch(parameters: parameters, result: { (productList) in
            XCTAssertFalse((productList.products!.first?.name?.contains("11123213"))!, "")
        }) { (error) in
            XCTAssertTrue(error.id == 101, "Error is what's going to happen.")
        }
    }
    
    func testSearch(parameters: [String: Any],
                    result: @escaping ((ProductList) -> Void),
                    failure: @escaping (errorHandler) = { _ in }) {
        let expect = expectation(description: "Should make a search using: \(parameters)")
        
        home.homePresenter.homeService.getProducts(parameters: parameters, result: { (productList) in
            // Check existing items
            XCTAssertNotNil(productList, "Product List should not be nil!")
            XCTAssertTrue((productList.products?.count)! > 0, "Product List should not be empty!")
            
            result(productList)
            
            expect.fulfill()
        }) { (error) in
            failure(error)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error, "Timed out. \(error?.localizedDescription ?? "error occured")")
        }
    }
}

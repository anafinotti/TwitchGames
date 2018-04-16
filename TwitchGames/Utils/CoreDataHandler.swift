//
//  CoreDataHandler.swift
//  TwitchGames
//
//  Created by Ana Finotti on 4/15/18.
//  Copyright © 2018 Finotti. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandler: NSObject {
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    class func saveObject(product: Product) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Game", in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
       // managedObject.setValue(product.sku, forKey: "sku")
        managedObject.setValue(product.name!, forKey: "name")
        managedObject.setValue(product.image, forKey: "image")
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
}

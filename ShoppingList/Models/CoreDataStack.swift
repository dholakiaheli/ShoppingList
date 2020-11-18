//
//  CoreDataStack.swift
//  ShoppingList
//
//  Created by Heli Bavishi on 11/13/20.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ShoppingList")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print(error)
                print(error.localizedDescription)
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext {
        return container.viewContext
    }
}

//
//  ShoppingListController.swift
//  ShoppingList
//
//  Created by Heli Bavishi on 11/13/20.
//

import Foundation
import CoreData

class ShoppingListController {
    
    static let shared = ShoppingListController()
    
    //fetched result controller
    let fetchedResultController: NSFetchedResultsController<Item> = {
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let veiledSort = NSSortDescriptor(key: "isCheck", ascending: false)
        fetchRequest.sortDescriptors = [veiledSort]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isCheck", cacheName: nil)
    }()
    
    init() {
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
    // CRUD
    //Create
    func createItem(name: String) {
        _ = Item(name: name)
        saveToPersistentStore()
    }
    
    //Delete
    func removeItem(item: Item) {
        item.managedObjectContext?.delete(item)
        saveToPersistentStore()
    }
    
    //update isCheck
    func isCheck(item: Item) {
        item.isCheck.toggle()
        saveToPersistentStore()
    }
    
    //Persistent
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
}

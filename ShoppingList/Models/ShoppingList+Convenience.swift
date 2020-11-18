//
//  ShoppingList+Convenience.swift
//  ShoppingList
//
//  Created by Heli Bavishi on 11/13/20.
//

import Foundation
import CoreData

extension Item {
    convenience init(name: String, isCheck: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.isCheck = isCheck
    }
}

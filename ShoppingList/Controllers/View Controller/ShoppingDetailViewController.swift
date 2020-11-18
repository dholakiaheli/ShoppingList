//
//  ShoppingDetailViewController.swift
//  ShoppingList
//
//  Created by Heli Bavishi on 11/13/20.
//

import UIKit

class ShoppingDetailViewController: UIViewController {
    
    var item: Item? {
        didSet {
            loadViewIfNeeded()
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let item = item else { return }
        self.title = item.name
    }
}
//Mock data for nutrition info
//    var mockItem: [Item] = {
//        let mockData = Item(calories: "290", fat: "23")
//        return [mockData]
//}()

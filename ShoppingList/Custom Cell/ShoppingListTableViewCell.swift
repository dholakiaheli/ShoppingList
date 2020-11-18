//
//  ShoppingListTableViewCell.swift
//  ShoppingList
//
//  Created by Heli Bavishi on 11/13/20.
//

import UIKit

protocol ShoppingListCellDelegate: AnyObject {
    func isCheckButtonTapped(_ sender: ShoppingListTableViewCell)
}

class ShoppingListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    var item: Item? {
        didSet {
            updateViews()
        }
    }
    weak var delegete: ShoppingListCellDelegate?
    
    @IBAction func isCheckButtonTapped(_ sender: Any) {
        delegete?.isCheckButtonTapped(self)
    }
    
    func updateViews() {
        guard let item = item else { return }
        itemNameLabel.text = item.name
        updateButton(for: item)
    }
    
    func updateButton(for item: Item) {
        if item.isCheck {
        self.checkButton.setImage(#imageLiteral(resourceName: "complete"), for: .normal)
        } else {
            self.checkButton.setImage(#imageLiteral(resourceName: "incomplete"), for: .normal)
        }
    }
}

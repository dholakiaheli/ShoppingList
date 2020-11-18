//
//  ShoppingListTableViewController.swift
//  ShoppingList
//
//  Created by Heli Bavishi on 11/13/20.
//

import UIKit
import CoreData

class ShoppingListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ShoppingListController.shared.fetchedResultController.delegate = self
    }
    
    @IBAction func createItemButtonTapped(_ sender: Any) {
        presentAlertController()
    }
    
    func presentAlertController() {
        let alertController = UIAlertController(title: "Add Item", message: "Please add an item to your shopping list", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter item's name..."
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let itemName = alertController.textFields?[0].text
                  else { return }
            ShoppingListController.shared.createItem(name: itemName)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ShoppingListController.shared.fetchedResultController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingListController.shared.fetchedResultController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if ShoppingListController.shared.fetchedResultController.sectionIndexTitles[section] == "0" {
            return "InComplete"
        }else {
            return "Complete"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell", for: indexPath) as? ShoppingListTableViewCell else { return UITableViewCell() }

        let itemToDisplay = ShoppingListController.shared.fetchedResultController.object(at: indexPath)
        cell.item = itemToDisplay
        cell.delegete = self

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = ShoppingListController.shared.fetchedResultController.object(at: indexPath)
            ShoppingListController.shared.removeItem(item: itemToDelete)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? ShoppingDetailViewController else { return }
            let itemToSend = ShoppingListController.shared.fetchedResultController.object(at: indexPath)
            destination.item = itemToSend
        }
    }
}

extension ShoppingListTableViewController: ShoppingListCellDelegate {
    func isCheckButtonTapped(_ sender: ShoppingListTableViewCell) {
        
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let item = ShoppingListController.shared.fetchedResultController.object(at: indexPath)
        ShoppingListController.shared.isCheck(item: item)
        sender.updateViews()
    }
}

extension ShoppingListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            let indexSet = IndexSet(integer: sectionIndex)
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            let indexSet = IndexSet(integer: sectionIndex)
            tableView.deleteSections(indexSet, with: .automatic)
        case .move:
            break
        case .update:
            break
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { break }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { break }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { break }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { break }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}

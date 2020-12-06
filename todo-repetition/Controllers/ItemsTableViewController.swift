//
//  ItemsTableViewController.swift
//  todo-repetition
//
//  Created by Carlos Cardona on 03/12/20.
//

import UIKit
import SwipeCellKit
import RealmSwift

class ItemsTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var items: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loaditem()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedCategory?.name
    }
    
    // MARK: - tableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items added yet"
        }
        return cell
    }
    
    
    // MARK: - tableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status: \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Data Manipulation Methods
    
    func loaditem() {
        items = selectedCategory?.items.sorted(byKeyPath: "createdDate", ascending: false)
        tableView.reloadData()
    }
    
    func saveItem(item: Item) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Error loading items: \(error)")
        }
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexpath: IndexPath) {
        super.updateModel(at: indexpath)
        
        if let item = items?[indexpath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting Item: \(error)")
            }
        }
    }
    
    
    
    // MARK: - Add new item Button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.createdDate = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error Saving new item: \(error)")
                }
                
                self.tableView.reloadData()
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new item"
            textField = alertTextField
        }
        
        present(alert, animated: true)
        
    }

}

//
//  ItemTableViewController.swift
//  Todo Apps
//
//  Created by DDD on 26/06/20.
//  Copyright © 2020 Dandun Adi. All rights reserved.
//

import UIKit
import RealmSwift

class ItemViewController: UITableViewController {
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    var items: Results<Item>?
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    
    //MARK: - Data manipulation methods
    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add to-do item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "To-do name"
            textField = alertTextField
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (alertAction) in
            do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    self.selectedCategory?.items.append(newItem)
                    self.tableView.reloadData()
                }
            } catch {
                print("Unable to save new to-do item \(error)")
            }
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isDone ? .checkmark : .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.isDone = !item.isDone
                }
            } catch {
                print("Unable to updating database \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

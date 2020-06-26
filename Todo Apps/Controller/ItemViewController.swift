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
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        title = selectedCategory?.name
        searchBar.delegate = self
        self.hideKeyboardWhenTappedAround()
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
    
    
    //MARK: - Table view swipe to delete
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if let selectedItem = items?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(selectedItem)
                        tableView.reloadData()
                    }
                } catch {
                    print("Unable to delete item \(error)")
                }
            }
        }
        
    }
}


//MARK: - Search Bar Delegate Method
extension ItemViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //checking if user didn't type anyting then press search
        if searchBar.text?.count == 0 {
            clearSearchBar()
            return
        }
        
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            clearSearchBar()
        }
    }
    
    func clearSearchBar() {
        loadItems()
        DispatchQueue.main.async {
            self.searchBar.resignFirstResponder()
        }
    }
    
    
    // dismiss keyboard when user tap outside
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

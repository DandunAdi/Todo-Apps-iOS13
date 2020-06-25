//
//  CategoryViewController.swift
//  Todo Apps
//
//  Created by DDD on 25/06/20.
//  Copyright © 2020 Dandun Adi. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        loadCategories()
    }
    
    //MARK: - Model manipulation methods
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func saveCategory(with category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Unable to save new category \(error)")
        }
        tableView.reloadData()
    }
    
    
    //MARK: - Add new category button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        var textField = UITextField()
        alert.addTextField { (actionTextField) in
            actionTextField.placeholder = "Category name"
            textField = actionTextField
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.saveCategory(with: newCategory)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category Available"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(categories?[indexPath.row].name ?? "nil")
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

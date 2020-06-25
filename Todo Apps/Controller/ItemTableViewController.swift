//
//  ItemTableViewController.swift
//  Todo Apps
//
//  Created by DDD on 26/06/20.
//  Copyright © 2020 Dandun Adi. All rights reserved.
//

import UIKit
import RealmSwift

class ItemTableViewController: UITableViewController {
    
    var selectedCategory: Category?

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

}

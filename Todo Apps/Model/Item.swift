//
//  Item.swift
//  Todo Apps
//
//  Created by DDD on 26/06/20.
//  Copyright © 2020 Dandun Adi. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

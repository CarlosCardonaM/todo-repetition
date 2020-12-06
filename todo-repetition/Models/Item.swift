//
//  Item.swift
//  todo-repetition
//
//  Created by Carlos Cardona on 04/12/20.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var createdDate = Date()
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}

//
//  Category.swift
//  todo-repetition
//
//  Created by Carlos Cardona on 04/12/20.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
}

//
//  Objects.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 11.08.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import RealmSwift

class Objects {
    var objectsStudied: Results<ObjectStudied>?
    
    init() {
        let realm = try! Realm()
        self.objectsStudied = realm.objects(ObjectStudied.self)
    }
}

//
//  Objects.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 11.08.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import RealmSwift

struct Objects {
    
    let objectsStudied: Results<ObjectStudied>?
    
    init() {
        let realm = try! Realm()
        self.objectsStudied = realm.objects(ObjectStudied.self)
    }
    
    static func newObject(name: String, family: ObjectStudied.Family) -> ObjectStudied {
        let object = ObjectStudied(name: name, family: family)
        let realm = try! Realm()
        try! realm.write {
            realm.add(object)
        }
        return object
    }
    
    func exportTo(fileURL: URL, callback: (Result<Bool>)->()) {
        
        guard let objects = objectsStudied else {
            callback(Result.error("There are no objects to export"))
            return
        }
        let sortedObjects = objects.sorted(byKeyPath: "_family")
        var objectsArray = [ObjectStudied]()
        for object in sortedObjects {
            objectsArray.append(object)
        }
        DataExportHelpers.exportArray(array: objectsArray, to: fileURL) { (result) in
            callback(result)
        }
    }

}

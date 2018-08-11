//
//  LabBook.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 30.06.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import UIKit
import RealmSwift

class LabBook: Object {
    
    let entries = List<LabBookEntry>()
    @objc dynamic var id = "myBeesExperimentLabBook"
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(newLabBook: Bool) {
        self.init()
        let realm = try! Realm()
        if newLabBook {
            try! realm.write {
                realm.add(self)
            }
        }
    }
        
    func exportTo(fileURL: URL, callback: (Result<Bool>)->()) {
        let entries = self.entries.sorted(byKeyPath: "date")
        var entriesArray = [LabBookEntry]()
        for entry in entries {
            entriesArray.append(entry)
        }
        DataExportHelpers.exportArray(array: entriesArray, to: fileURL) { (result) in
            callback(result)
        }
    }
}

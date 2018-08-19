//
//  LabBook.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 30.06.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import UIKit
import RealmSwift

class LabBook: Object, JSONExportable {
    
    let entries = List<LabBookEntry>()
    @objc dynamic var id = "myBeesExperimentLabBook"
    let displayText = "Labbook"
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func makeNew() -> LabBook {
        let newLabBook = LabBook.init()
        let realm = try! Realm()
        try! realm.write {
            realm.add(newLabBook)
        }
        return newLabBook
    }
    
    static func open() -> LabBook? {
        let realm = try! Realm()
        let myBeesExperimentLabBook = realm.object(ofType: LabBook.self, forPrimaryKey: "myBeesExperimentLabBook")
        return myBeesExperimentLabBook
    }
    
    func addEntry(_ entry: LabBookEntry) {
        let realm = try! Realm()
        try! realm.write {
            entries.append(entry)
        }
    }
        
    func exportAsJSON(callback: (Result<Bool>)->()) {
        guard let fileURL = try? DataExportHelpers.generateFileURLForBaseString("LabBook", withExtension: "json") else {
            callback(Result.error("File could not be opened"))
            return
        }
        let entries = self.entries.sorted(byKeyPath: "date")
        var entriesArray = [LabBookEntry]()
        for entry in entries {
            entriesArray.append(entry)
        }
        DataExportHelpers.exportArray(array: entriesArray, to: fileURL) { (result) in
            callback(result)
        }
    }
    
    func exportAsJSON2(callback: (Result<URL>)->()) {
        guard let fileURL = try? DataExportHelpers.generateFileURLForBaseString("LabBook", withExtension: "json") else {
            callback(Result.error("File could not be opened"))
            return
        }
        let entries = self.entries.sorted(byKeyPath: "date")
        var entriesArray = [LabBookEntry]()
        for entry in entries {
            entriesArray.append(entry)
        }
        DataExportHelpers.exportArray(array: entriesArray, to: fileURL) { (result) in
            callback(Result.success(fileURL))
        }
    }
}

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
    
    func exportTo(fileURL: URL, callback: (Result<Bool>)->()) {
            do {
                let entries = self.entries.sorted(byKeyPath: "date")
                var entriesArray = [LabBookEntry]()
                for entry in entries {
                    entriesArray.append(entry)
                }
                let jsonEncoder = JSONEncoder()
                jsonEncoder.dateEncodingStrategy = .formatted(DataExportHelpers.dateFormatterWithMilliseconds)
                do {
                    let jsonData = try jsonEncoder.encode(entriesArray)
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        print(jsonString)
                    }
                    do {
                        try jsonData.write(to: fileURL, options: .withoutOverwriting)
                        
                        // here is a nice converter to csv: https://json-csv.com
                        // use the "header / detail report style" for nicest representation
                        callback(Result.success(true))
                    } catch {
                        callback(Result.error("writing file failed"))
                        print(error)
                    }
                } catch {
                    callback(Result.error("JSON encoding failed"))
                    print(error)
                }
            }
//        } catch {
//            print(error)
//        }
    }


}

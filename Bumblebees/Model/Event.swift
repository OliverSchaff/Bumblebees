//
//  FlowerVisit.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 30.06.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import RealmSwift

@objcMembers class Event: Object, Encodable {
    
    dynamic var date: Date = Date()
    dynamic var index: Int = 0
    
    func delete() {
        let realm = try! Realm()
        if realm.isInWriteTransaction {
            realm.delete(self)
        } else {
            try! realm.write {
                realm.delete(self)
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case date
        case index
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date as Date, forKey: .date)
        try container.encode(index, forKey: .index)
    }


}

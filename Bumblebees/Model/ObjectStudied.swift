//
//  Species.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 30.06.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import RealmSwift
import Realm

class ObjectStudied: Object, Encodable {
    
    enum Family: String {
        
        var familyName: String {
            get {
                switch self {
                case .bee:
                    return self.rawValue
                case .flower:
                    return self.rawValue
                }
            }
        }
        
        case bee = "Bee"
        case flower = "Flower"
    }
    
    @objc dynamic var _family: String = ""
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var creationDate: Date = Date()
    @objc dynamic var name: String = ""
    @objc dynamic var comment: String?
    let observedEvents = List<Event>()
    
    var family: Family {
        get {
            let f = ObjectStudied.Family(rawValue: _family)!
            return f
        }
    }

    convenience init(name: String, family: Family) {
        self.init()
        self.name = name
        self._family = family.rawValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func delete() {
        let realm = try! Realm()
        if realm.isInWriteTransaction {
            for visit in self.observedEvents {
                visit.delete()
            }
            realm.delete(self)
        } else {
            try! realm.write {
                for visit in self.observedEvents {
                    visit.delete()
                }
                realm.delete(self)
            }
        }
    }
    
    func changeNameTo(newName: String) {
        let realm = try! Realm()
        try! realm.write {
            name = newName
        }
    }
    
    func changeCommentTo(newComment: String) {
        let realm = try! Realm()
        try! realm.write {
            comment = newComment
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case family
        case id
        case name
        case observedEvents
        case comment
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_family, forKey: .family)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        var observedEventsArray = [Event]()
        for event in observedEvents {
            observedEventsArray.append(event)
        }
        try container.encode(observedEventsArray, forKey: .observedEvents)
        try container.encode(comment, forKey: .comment)
    }

}


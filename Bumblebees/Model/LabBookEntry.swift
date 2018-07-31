//
//  LabBookEntry.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 30.06.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import Foundation
import RealmSwift

class LabBookEntry: Object, Encodable {
    
    @objc dynamic var date: Date = Date()
    @objc dynamic var text: String = ""
    
    enum CodingKeys: String, CodingKey {
        case date
        case text
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date as Date, forKey: .date)
        try container.encode(text, forKey: .text)
    }

    
}


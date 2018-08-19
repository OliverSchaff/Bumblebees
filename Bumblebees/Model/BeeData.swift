//
//  File.swift
//  CoreDataPractice
//
//  Created by Oliver Schaff on 16.06.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import Foundation

class BeeData: NameProvider {
    
    let name: String
    
    static var nameIndex = 0
    static var availableNames = [String]()
    static private var nameStock = ["Amaya", "Noe", "Julius", "Carolina", "Aria", "Meghan", "Braylon", "Celia", "Alijah", "Mathew", "Diego", "Arely", "Stacy", "Mareli", "Brendan", "Harrison", "Olive", "Litzy", "Deven", "Lilliana", "Liam", "Kenley", "Hana", "Devin", "Ali", "Judah", "Carlee", "Fletcher", "Maleah", "Jayla", "Beckham", "Leonidas", "Kyra", "Finnegan", "Genevieve", "Vivian", "Kristin", "Janet", "Alison", "Howard", "Frank", "Ignacio", "Elizabeth", "Zion", "Journey", "Vaughn", "Mateo", "Bridger", "Jaxson", "Mikayla"]

    init() {
        if BeeData.availableNames.count == 0 {
            let namesWithIndex = BeeData.nameStock.map { (name) -> String in
                if BeeData.nameIndex == 0 {
                    return name
                } else {
                    return name + String(BeeData.nameIndex)
                }
            }
            BeeData.availableNames = namesWithIndex
            BeeData.nameIndex += 1
        }
        let index = Int(arc4random_uniform(UInt32(BeeData.availableNames.count)))
        self.name = BeeData.availableNames.remove(at: index)
    }
}

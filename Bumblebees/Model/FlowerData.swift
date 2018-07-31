//
//  FlowerData.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 21.07.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import Foundation

class FlowerData: NameProvider {
    let name: String
    let id: UUID
    
    static var nameIndex = 0
    static var availableNames = [String]()
    static private var nameStock = [
        "Korin",
        "Mist",
        "Arwen",
        "Kyle",
        "Silver",
        "Sparrow",
        "Light",
        "Tyler",
        "Roman",
        "Keenak",
        "Justice",
        "Blue",
        "Fray",
        "Dusk",
        "Nug",
        "Cypress",
        "Quincy",
        "Sierra",
        "Harbor",
        "Brave",
        "Sunray",
        "Leary",
        "Saturn",
        "Crimson",
        "Moonshine",
        "Arwen",
        "Jaco",
        "March",
        "Tyler",
        "Phoenix"
        ]
    
    init() {
        if FlowerData.availableNames.count == 0 {
            let namesWithIndex = FlowerData.nameStock.map { (name) -> String in
                if FlowerData.nameIndex == 0 {
                    return name
                } else {
                    return name + String(FlowerData.nameIndex)
                }
            }
            FlowerData.availableNames = namesWithIndex
            FlowerData.nameIndex += 1
        }
        let index = Int(arc4random_uniform(UInt32(FlowerData.availableNames.count)))
        self.name = FlowerData.availableNames.remove(at: index)
        self.id = UUID()
    }
}

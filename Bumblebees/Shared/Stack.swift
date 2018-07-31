//
//  Stack.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 29.07.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

struct Stack<Element> {
    var items = [Element]()
    
    mutating func push(_ event: Element) {
        items.append(event)
    }
    
    @discardableResult
    mutating func pop() -> Element {
        return items.removeLast()
    }
    
    func peek() -> Element? {
        return items.last
    }
}

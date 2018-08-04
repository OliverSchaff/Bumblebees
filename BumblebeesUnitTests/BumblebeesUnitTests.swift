//
//  BumblebeesUnitTests.swift
//  BumblebeesUnitTests
//
//  Created by Oliver Schaff on 04.08.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import XCTest
@testable import Bumblebees

class BumblebeesUnitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStackPush() {
        var stack = Stack<Int>()
        let a = 1
        stack.push(a)
        XCTAssert(!stack.items.isEmpty, "stack.push not working")
        XCTAssert(stack.items.last! == a, "stack push not working")
    }
    
    func testStackPull() {
        var stack = Stack<Int>()
        let a = 1
        stack.push(a)
        let aa = stack.pop()
        XCTAssert(a == aa, "stack.pop not working")
    }
    
    func testStackPeek() {
        var stack = Stack<Int>()
        let a = 1
        stack.push(a)
        let ap = stack.peek()
        XCTAssert(a == ap, "stack.peek not working")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

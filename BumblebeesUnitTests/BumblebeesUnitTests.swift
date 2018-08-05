//
//  BumblebeesUnitTests.swift
//  BumblebeesUnitTests
//
//  Created by Oliver Schaff on 04.08.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import XCTest
import RealmSwift
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
    
    func testLabBookPersistence() {
        let realm = try! Realm()
        if let oldLabBook = realm.object(ofType: LabBook.self, forPrimaryKey: "myBeesExperimentLabBook") {
            try! realm.write {
                realm.delete(oldLabBook)
            }
        }
        let labBook = realm.object(ofType: LabBook.self, forPrimaryKey: "myBeesExperimentLabBook") ?? LabBook()
        try! realm.write {
            realm.add(labBook)
        }
        let entry = LabBookEntry()
        let url = try! DataExportHelpers.generateFileURLForBaseString("UnitTestLabBook", withExtension: "json")
        entry.date = Date(timeIntervalSinceReferenceDate: 1000.0)
        entry.text = "unitTest"
        try! realm.write {
            labBook.entries.append(entry)
        }
        
        guard let labBookFromRealm = realm.object(ofType: LabBook.self, forPrimaryKey: "myBeesExperimentLabBook") else {
            XCTAssert(false, "LabBook  was not persisted into Realm")
            return
        }
        XCTAssert(labBookFromRealm.entries[0].text == "unitTest", "labBook entry.text was not correctly persisted in Realm")
        XCTAssert(labBookFromRealm.entries[0].date == Date(timeIntervalSinceReferenceDate: 1000.0), "labBook entry.date was not correctly persisted in Realm")
        labBook.exportTo(fileURL: url) { (result) in
            switch result {
            case .error(let error):
                print(error)
            case .success:
                let fileManager = FileManager.default
                let path = url.path
                XCTAssert(fileManager.fileExists(atPath: path), "labBook file has not been created")
            }
        }
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}

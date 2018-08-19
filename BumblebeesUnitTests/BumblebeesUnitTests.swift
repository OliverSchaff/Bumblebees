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
    
    let realm = try! Realm()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try! realm.write {
            realm.deleteAll()
        }
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
        let labBook = LabBook.makeNew()
        let entry = LabBookEntry()
        entry.date = Date(timeIntervalSinceReferenceDate: 1000.0)
        entry.text = "unitTest"
        labBook.addEntry(entry)
        
        if let existingLabBook = LabBook.open() {
            XCTAssert(existingLabBook.entries[0].text == "unitTest", "labBook entry.text was not correctly persisted in Realm")
            XCTAssert(existingLabBook.entries[0].date == Date(timeIntervalSinceReferenceDate: 1000.0), "labBook entry.date was not correctly persisted in Realm")
        } else {
            XCTAssert(false, "Labbook was not correctly persisted in Realm")
        }
        labBook.exportAsJSON2 { (result) in
            switch result {
            case .error(let error):
                print(error)
                XCTAssert(false, "creating labBook file failed")
            case .success(let url):
                let fileManager = FileManager.default
                let path = url.path
                XCTAssert(fileManager.fileExists(atPath: path), "labBook file has not been created")
            }

        }
    }
    
    func testObjectsPersistence() {
        let objects = Objects()
        let beeData = BeeData()
        let anotherBeeData = BeeData()
        XCTAssert(beeData.name != anotherBeeData.name, "BeeData generated two identical names")
        let bee = Objects.newObject(name: beeData.name, family: .bee)
        bee.changeCommentTo(newComment: "BeeComment")
        bee.changeNameTo(newName: "BeeName")
        let firstBeeEvent = bee.newEvent(newSubject: true)
        let secondBeeEvent = bee.newEvent(newSubject: true)
        let thirdBeeEvent = bee.newEvent(newSubject: false)
        let predicate = NSPredicate(format: "_family = %@", ObjectStudied.Family.bee.rawValue)
        guard let beeFromRealm = objects.objectsStudied?.filter(predicate).first else {
            XCTAssert(false, "Bee was not properly persisted in Realm")
            return
        }
        XCTAssertTrue(beeFromRealm.id == bee.id)
        XCTAssertTrue(beeFromRealm.family == bee.family)
        XCTAssertTrue(beeFromRealm._family == bee._family)
        XCTAssertTrue(beeFromRealm.creationDate == bee.creationDate)
        XCTAssert(beeFromRealm.name == "BeeName", "bee.name was not properly persisted in Realm")
        XCTAssert(beeFromRealm.comment == "BeeComment", "bee.comment was not properly persisted in Realm")
        guard beeFromRealm.observedEvents.count == 3 else {
            XCTAssert(false, "Event from bee was not properly persisted in Realm")
            return
        }
        let event0 = beeFromRealm.observedEvents[0]
        let event1 = beeFromRealm.observedEvents[1]
        let event2 = beeFromRealm.observedEvents[2]
        XCTAssertTrue(event0.date == firstBeeEvent.date)
        XCTAssertTrue(event1.date == secondBeeEvent.date)
        XCTAssertTrue(event2.date == thirdBeeEvent.date)
        XCTAssertTrue(event0.index == 1)
        XCTAssertTrue(event1.index == 2)
        XCTAssertTrue(event2.index == 2)
        
        let flowerData = FlowerData()
        let anotherFlowerData = FlowerData()
        XCTAssert(flowerData.name != anotherFlowerData.name, "FlowerData generated two identical names")
        let flower = Objects.newObject(name: beeData.name, family: .flower)
        let flowerPredicate = NSPredicate(format: "_family = %@", ObjectStudied.Family.flower.rawValue)
        guard let flowerFromRealm = objects.objectsStudied?.filter(flowerPredicate).first else {
            XCTAssert(false, "Flower was not properly persisted in Realm")
            return
        }
        XCTAssertTrue(flowerFromRealm.id == flower.id)
        XCTAssertTrue(flowerFromRealm.family == flower.family)
        XCTAssertTrue(flowerFromRealm._family == flower._family)
        beeFromRealm.delete()
        XCTAssert(objects.objectsStudied?.count == 1, "Deletion of objectStudied from Realm failed")
    }
    
    func testNightMode() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        XCTAssertNotNil(sb, "Could not instantiate storyboard")
        let entryVC = sb.instantiateViewController(withIdentifier: "entryVC") as? EntryVC
        XCTAssertNotNil(entryVC, "Could not instantiate EntryVC")
        _ = entryVC!.view
        
        entryVC!.themeProvider.currentTheme = .dark
        let oldColor = entryVC!.view.backgroundColor
        entryVC!.themeProvider.currentTheme = .light
        let newColor = entryVC!.view.backgroundColor
        XCTAssert(oldColor != newColor, "night mode did not change colors")
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}

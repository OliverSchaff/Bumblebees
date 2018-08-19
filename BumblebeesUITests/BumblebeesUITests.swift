//
//  BumblebeesUITests.swift
//  BumblebeesUITests
//
//  Created by Oliver Schaff on 05.08.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Bumblebees

class BumblebeesUITests: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launchArguments.append("--uitesting")
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShare() {
        let shareButton = app.buttons["ShareButton"]
        XCTAssertTrue(shareButton.exists)
        shareButton.tap()
        let cancel = app.buttons["Cancel"]
        let cancelExists = cancel.waitForExistence(timeout: 5.0)
        XCTAssertTrue(cancelExists)
        cancel.tap()
        XCTAssertFalse(cancel.exists)
        XCUIApplication().navigationBars["Bumblebees"].otherElements["Bumblebees"].tap()
        
    }
    
    func testExperimentWithNewBee() {
        
        // tap the cell that leads to the bee experiment setup
        let entryTable = app.tables["EntryTable"]
        let entryTableExists = entryTable.waitForExistence(timeout: 5.0)
        XCTAssertTrue(entryTableExists)
        let beeExperimentCell = entryTable.cells["BeeExperimentCell"]
        beeExperimentCell.tap()
        
        // check if the bee experiment setup table opened
        let beeExperimentSetupTable = app.tables["ExperimentSetupTable"]
        let beeExperimentSetupExists = beeExperimentSetupTable.waitForExistence(timeout: 5.0)
        XCTAssertTrue(beeExperimentSetupExists)
        
        // tap the newBee button (it is the second button, thus "boundBy 1")
        let newBeeButton = app.navigationBars.buttons.element(boundBy: 1)
        newBeeButton.tap()

        // tap save
        let saveButton = app.buttons["Save"]
        saveButton.tap()
        
        // check if the new bee is shown in the table
        let objectsTable = app.otherElements["ObjectsTable"]
        XCTAssertTrue(objectsTable.cells.count == 1)
        
        // tap Start Experiment Button
        let startCell = beeExperimentSetupTable.cells["StartExperimentCell"]
        XCTAssertTrue(startCell.exists)
        let startExperimentButton = startCell.buttons.element(boundBy: 0)
        startExperimentButton.tap()
        
        // tap new bee again
        let newBeeButtonInExperiment = app.navigationBars.buttons.element(boundBy: 1)
        newBeeButtonInExperiment.tap()
        
        // tap Cancel
        let cancelButton = app.buttons["Cancel"]
        cancelButton.tap()
        
        // store text of visits label
        let visitsText = app.staticTexts["VisitsLabel"].label
        
        // tap right, left, undo buttons
        app.otherElements["RightButton"].tap()
        app.otherElements["LeftButton"].tap()
        app.otherElements["UndoButton"].tap()

        // check that the visits counter changed
        let newVisitsText = app.staticTexts["VisitsLabel"].label
        XCTAssertTrue(visitsText != newVisitsText)

        // tap help button
        let helpButton = app.buttons["HelpButton"]
        helpButton.tap()
        
        // tap OK button
        let okButton = app.buttons["OK"]
        okButton.tap()

        
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        backButton.tap()
        backButton.tap()
    }
    
}

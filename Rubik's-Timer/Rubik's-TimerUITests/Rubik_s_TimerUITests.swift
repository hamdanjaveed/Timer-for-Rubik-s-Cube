//
//  Rubik_s_TimerUITests.swift
//  Rubik's-TimerUITests
//
//  Created by Hamdan Javeed on 2018-07-23.
//  Copyright © 2018 Hamdan Javeed. All rights reserved.
//

import XCTest

class Rubik_s_TimerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launchArguments = ["--ui-testing"]
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMultipleSolvesShowOnSolveTable() {
        let app = XCUIApplication()
        let timer = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element

        // Record a solve
        timer.tap()
        timer.tap()
        timer.tap()

        // Check to see if 1 solve appears
        app.tabBars.buttons["Solves"].tap()
        let solveCount = app.tables["SolveTable"].cells.count
        XCTAssertEqual(solveCount, 1, "Expected to see 1 solve, found \(solveCount)")

        // Record another solve
        app.tabBars.buttons["Timer"].tap()
        timer.tap()
        timer.tap()
        timer.tap()
        app.tabBars.buttons["Solves"].tap()

        // Check to see if 2 solves appear
        let updatedSolveCount = app.tables["SolveTable"].cells.count
        XCTAssertEqual(updatedSolveCount, 2, "Expected to see 2 solves, found \(updatedSolveCount)")
    }
    
}

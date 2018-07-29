//
//  Rubik_s_TimerUnitTests.swift
//  Rubik's-TimerUnitTests
//
//  Created by Hamdan Javeed on 2018-07-29.
//  Copyright © 2018 Hamdan Javeed. All rights reserved.
//

import XCTest
@testable import Rubik_s_Timer

class Rubik_s_TimerUnitTests: XCTestCase {
    let userDefaults = UserDefaults()

    override func setUp() {
        UserSettings.prefs = userDefaults
    }

    override func tearDown() {
        userDefaults.dictionaryRepresentation().keys.forEach { key in
            userDefaults.removeObject(forKey: key)
        }

        super.tearDown()
    }

    func testInspectionTimer() {
        let inspectionTimes = [
            -10: 0,
            0: 0,
            10: 10
        ]

        inspectionTimes.forEach { input, expected in
            UserSettings.setInspectionTime(to: input)

            let found = userDefaults.integer(forKey: UserSettings.inspectionTimeKey)
            XCTAssertEqual(expected, found, "Failed to set inspection time, expected \(expected), found \(found)")
        }
    }
}

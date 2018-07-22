//
//  UserSettings.swift
//  Rubik's-Timer
//
//  Created by Hamdan Javeed on 2018-07-22.
//  Copyright © 2018 Hamdan Javeed. All rights reserved.
//

import UIKit

class UserSettings: NSObject {
    private static let prefs = UserDefaults.standard

    private static let inspectionTimeKey = "settings_inspectionTime"

    class func setInspectionTime(to inspectionTime: Float) {
        setInspectionTime(to: Int(inspectionTime))
    }

    class func setInspectionTime(to inspectionTime: Int) {
        prefs.set(inspectionTime, forKey: UserSettings.inspectionTimeKey)
    }

    class func getInspectionTime() -> Int {
        return prefs.integer(forKey: UserSettings.inspectionTimeKey)
    }
}

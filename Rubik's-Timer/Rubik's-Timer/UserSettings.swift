//
//  UserSettings.swift
//  Rubik's-Timer
//
//  Created by Hamdan Javeed on 2018-07-22.
//  Copyright © 2018 Hamdan Javeed. All rights reserved.
//

import UIKit

class UserSettings {
    static var prefs = UserDefaults.standard

    static let inspectionTimeKey = "settings_inspectionTime"
    static let hideInspectionTimerKey = "settings_hideInspectionTimer"
    static let hideSolveTimerKey = "settings_hideSolveTimer"

    class func registerDefaultUserSettings() {
        if let defaultUserSettings = PropertyListSerialization.dictionary(fromResource: "UserSettingDefaults", ofType: "plist", withFormat: .xml) {
            prefs.register(defaults: defaultUserSettings)
        }
    }

    // MARK: Inspection
    class func setInspectionTime(to inspectionTime: Float) {
        setInspectionTime(to: Int(inspectionTime))
    }

    class func setInspectionTime(to inspectionTime: Int) {
        let correctInspectionTime = (inspectionTime < 0) ? 0 : inspectionTime
        prefs.set(correctInspectionTime, forKey: UserSettings.inspectionTimeKey)
    }

    class func getInspectionTime() -> Int {
        return prefs.integer(forKey: UserSettings.inspectionTimeKey)
    }

    class func setInspectionTimerVisibility(to visible: Bool) {
        prefs.set(visible, forKey: hideInspectionTimerKey)
    }

    class func isInspectionTimerVisible() -> Bool {
        return prefs.bool(forKey: hideInspectionTimerKey)
    }

    // MARK: Solving
    class func setSolveTimerVisibility(to visible: Bool) {
        prefs.set(visible, forKey: hideSolveTimerKey)
    }

    class func isSolveTimerVisible() -> Bool {
        return prefs.bool(forKey: hideSolveTimerKey)
    }
}

extension PropertyListSerialization {
    static func dictionary(fromResource resource: String, ofType type: String, withFormat format: PropertyListFormat) -> [String:Any]? {
        guard let path = Bundle.main.path(forResource: resource, ofType: type) else {
            print("No file found at path \(resource).\(type)")
            return nil
        }

        guard let data = FileManager.default.contents(atPath: path) else {
            print("Unable to convert file at path \(path) to data")
            return nil
        }

        var plistFormat = PropertyListSerialization.PropertyListFormat.xml
        return try? PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: &plistFormat) as! [String:Any]
    }
}

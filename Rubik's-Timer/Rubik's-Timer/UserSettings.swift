//
//  UserSettings.swift
//  Rubik's-Timer
//
//  Created by Hamdan Javeed on 2018-07-22.
//  Copyright © 2018 Hamdan Javeed. All rights reserved.
//

import UIKit

class UserSettings {
    private static let prefs = UserDefaults.standard

    private static let inspectionTimeKey = "settings_inspectionTime"
    private static let hideInspectionTimerKey = "settings_hideInspectionTimer"
    private static let hideSolveTimerKey = "settings_hideSolveTimer"

    class func registerDefaultUserSettiings() {
        if let defaultUserSettingsPath = Bundle.main.path(forResource: "UserSettingDefaults", ofType: "plist"), let defaultUserSettingsPlist = FileManager.default.contents(atPath: defaultUserSettingsPath) {
            var defaultUserSettingsPlistFormat = PropertyListSerialization.PropertyListFormat.xml
            do {
                let defaultUserSettings = try PropertyListSerialization.propertyList(from: defaultUserSettingsPlist, options: .mutableContainers, format: &defaultUserSettingsPlistFormat) as! [String:Any]
                prefs.register(defaults: defaultUserSettings)
            } catch {
                print("Error trying to get default user settings: \(error)")
            }
        }
    }

    // MARK: Inspection
    class func setInspectionTime(to inspectionTime: Float) {
        setInspectionTime(to: Int(inspectionTime))
    }

    class func setInspectionTime(to inspectionTime: Int) {
        prefs.set(inspectionTime, forKey: UserSettings.inspectionTimeKey)
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

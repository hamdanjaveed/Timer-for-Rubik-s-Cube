//
//  SettingsTableViewController.swift
//  Rubik's-Timer
//
//  Created by Hamdan Javeed on 2018-07-21.
//  Copyright © 2018 Hamdan Javeed. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    private let prefs = UserDefaults.standard

    @IBOutlet weak var inspectionTimeLabel: UILabel!
    @IBOutlet weak var inspectionTimeSlider: UISlider!

    override func viewDidLoad() {
        let inspectionTime = UserSettings.getInspectionTime()
        updateInspectionTimeUI(with: inspectionTime)
    }

    // MARK: Inspection Time
    @IBAction func inspectionTimeChanged(_ sender: UISlider) {
        let inspectionTime = Int(sender.value)
        updateInspectionTimeLabel(with: inspectionTime)

        UserSettings.setInspectionTime(to: sender.value)
    }

    private func updateInspectionTimeUI(with inspectionTime: Int) {
        updateInspectionTimeLabel(with: inspectionTime)
        updateInspectionTimeSlider(with: Float(inspectionTime))
    }

    private func updateInspectionTimeSlider(with inspectionTime: Float) {
        inspectionTimeSlider.value = inspectionTime
    }

    private func updateInspectionTimeLabel(with inspectionTime: Int) {
        switch inspectionTime {
        case 0:
            inspectionTimeLabel.text = "Off"
        case 1:
            inspectionTimeLabel.text = "1 second"
        default:
            inspectionTimeLabel.text = "\(inspectionTime) seconds"
        }
    }
}

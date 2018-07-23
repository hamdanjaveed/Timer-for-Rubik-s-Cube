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

    override func viewDidLoad() {
        updateInspectionUI()
        updateSolvingUI()
    }

    // MARK: Inspection
    @IBOutlet weak var inspectionTimeLabel: UILabel!
    @IBOutlet weak var inspectionTimeSlider: UISlider!
    @IBOutlet weak var hideInspectionTimerSwitch: UISwitch!

    @IBAction func inspectionTimeChanged(_ sender: UISlider) {
        let inspectionTime = Int(sender.value)
        updateInspectionTimeLabel(with: inspectionTime)

        UserSettings.setInspectionTime(to: sender.value)
    }

    @IBAction func hideInspectionTimerChanged(_ sender: UISwitch) {
        UserSettings.setInspectionTimerVisibility(to: sender.isOn)
    }

    private func updateInspectionUI() {
        let inspectionTime = UserSettings.getInspectionTime()

        updateInspectionTimeLabel(with: inspectionTime)

        inspectionTimeSlider.value = Float(inspectionTime)
        hideInspectionTimerSwitch.isOn = UserSettings.isInspectionTimerVisible()
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

    // MARK: Solving
    @IBOutlet weak var hideSolveTimerSwitch: UISwitch!

    @IBAction func hideSolveTimerChanged(_ sender: UISwitch) {
        UserSettings.setSolveTimerVisibility(to: sender.isOn)
    }

    private func updateSolvingUI() {
        hideSolveTimerSwitch.isOn = UserSettings.isSolveTimerVisible()
    }
}

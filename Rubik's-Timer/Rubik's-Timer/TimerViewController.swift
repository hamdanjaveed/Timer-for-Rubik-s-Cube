//
//  TimerViewController.swift
//  Rubik's-Timer
//
//  Created by Hamdan Javeed on 2018-07-18.
//  Copyright © 2018 Hamdan Javeed. All rights reserved.
//

import UIKit

enum TimerState {
    case STOPPED
    case INSPECTING
    case SOLVING
    case FINISHED_SOLVING
}

let inspectTime = 5 // TODO: use prefs

class TimerViewController: UIViewController {
    @IBOutlet weak var timerLabel: UILabel!

    var currentState = TimerState.STOPPED
    var updateTimer: Timer?
    var timerBegin: Date?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch currentState {
        case .SOLVING:
            stopSolving()
        default:
            break
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch currentState {
        case .STOPPED:
            // Either start inspection or solving
            startInspection()
        case .INSPECTING:
            stopInspection()
        case .FINISHED_SOLVING:
            currentState = .STOPPED
            stopUpdateTimer()
        default:
            break
        }
    }

    func startInspection() {
        currentState = .INSPECTING
        timerBegin = Date()
        startUpdateTimer()
    }

    func stopInspection() {
        startSolving()
    }

    func startSolving() {
        currentState = .SOLVING
        timerBegin = Date()
    }

    func stopSolving() {
        currentState = .FINISHED_SOLVING
        if let begin = timerBegin {
            let solveTime = -begin.timeIntervalSinceNow
            timerLabel.text = solveTime.format()
            print("Solved in \(solveTime)")
        }
    }

    func startUpdateTimer() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { _ in
            if let begin = self.timerBegin {
                if self.currentState == .INSPECTING {
                    let inspectionTimeLeft = inspectTime + Int(begin.timeIntervalSinceNow)
                    if inspectionTimeLeft <= 0 {
                        self.stopInspection()
                    } else {
                        self.timerLabel.text = String(inspectionTimeLeft)
                    }
                } else if self.currentState == .SOLVING {
                    self.timerLabel.text = (-begin.timeIntervalSinceNow).format()
                }
            }
        })
    }

    func stopUpdateTimer() {
        updateTimer?.invalidate()
    }
}

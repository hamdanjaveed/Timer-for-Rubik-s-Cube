//
//  TimerViewController.swift
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 2015-03-31.
//  Copyright (c) 2015 Hamdan Javeed. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, TimerStateMachineDelegate {
    
    var stateMachine: TimerStateMachine = TimerStateMachine()
    var timer: NSTimer?
    var startTime: NSTimeInterval?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateMachine.delegate = self
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        stateMachine.touchBegan()
    }

    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        stateMachine.touchEnded()
    }
    
    func timerPrimed() {
        println("Timer primed")
    }
    
    func timerBegan() {
        println("Timer began")
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "timerTick:", userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
    }
    
    func timerStopped() {
        println("Timer stopped")
        var elapsedTime = NSDate.timeIntervalSinceReferenceDate() - startTime!
        timer?.invalidate()
        timer = nil
    }

    func timerTick(timer: NSTimer!) {
        println("Timer fired")
    }

}

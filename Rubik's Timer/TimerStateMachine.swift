//
//  TimerStateMachine.swift
//  Rubik's Timer
//
//  Created by Hamdan Javeed on 2015-03-31.
//  Copyright (c) 2015 Hamdan Javeed. All rights reserved.
//

protocol TimerStateMachineDelegate {
    func timerPrimed()
    func timerBegan()
    func timerStopped()
}

class TimerStateMachine {
    
    enum State {
        case Idle, Primed, Running
    }
    
    var state: State = .Idle
    var delegate: TimerStateMachineDelegate?
    
    init() {
        
    }
    
    func touchBegan() {
        switch (state) {
            case .Idle:
                state = .Primed
                self.delegate?.timerPrimed()
            case .Primed:
                state = .Primed
            case .Running:
                state = .Idle
                self.delegate?.timerStopped()
        }
    }
    
    func touchEnded() {
        switch (state) {
        case .Idle:
            state = .Idle
        case .Primed:
            state = .Running
            self.delegate?.timerBegan()
        case .Running:
            state = .Running
        }
    }
    
}

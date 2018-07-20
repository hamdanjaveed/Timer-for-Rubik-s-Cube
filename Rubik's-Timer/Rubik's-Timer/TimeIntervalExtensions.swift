//
//  TimeIntervalExtensions.swift
//  Rubik's-Timer
//
//  Created by Hamdan Javeed on 2018-07-19.
//  Copyright © 2018 Hamdan Javeed. All rights reserved.
//

import Foundation

extension TimeInterval {
    func format() -> String? {
        let seconds = Int(self)
        let hundredths = Int((self * 100.0).truncatingRemainder(dividingBy: 100.0))
        return String(format: "%02d:%02d", seconds, hundredths)
    }
}

//
//  SolveViewController.swift
//  Rubik's-Timer
//
//  Created by Hamdan Javeed on 2018-07-21.
//  Copyright © 2018 Hamdan Javeed. All rights reserved.
//

import UIKit

class SolveViewController: UIViewController {
    var solve: Solve!

    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var scrambleLabel: UILabel!

    override func viewDidLoad() {
        timeLabel.text = String(solve.time)
        dateLabel.text = solve.date?.description
        scrambleLabel.text = solve.scramble
    }
}

//
//  GameEngine.swift
//  colorpicker
//
//  Created by Colin Jao on 5/13/17.
//  Copyright © 2017 Colin Jao. All rights reserved.
//

import UIKit

class GameEngine: NSObject {
    
    var score: Int = 0
    var round: Int = 0
    var timer: Double = 0.0
    
    override init() {
        self.score = 0
        self.round = 1
    }
    
    func setTimer(time: Double) {
        timer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)

    }

}

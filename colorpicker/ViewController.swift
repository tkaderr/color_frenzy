//
//  ViewController.swift
//  colorpicker
//
//  Created by Colin Jao on 5/12/17.
//  Copyright © 2017 Colin Jao. All rights reserved.
//

import UIKit
import CoreData
import CoreMotion
import AudioToolbox
import AVFoundation

class ViewController: UIViewController {
    //############
    //GAME SECTION
    //############
    

    // Game Variables
    var motionManager: CMMotionManager?
    var detectShake = false
    var gameInProgress: Bool = true
    var score: Int = 0
    var roundScore: Int = 0
    var gameRound: Int = 0
    var timer = Timer()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var matched = false
    var randColor = (1,1,1)
    var contrast = (0,0,0)
    var roundInProgress: Bool = false
    var colorArr = [(Int,Int,Int)]()
    var audioPlayer = AVAudioPlayer()
    var successSound = AVAudioPlayer()
    var failureSound = AVAudioPlayer()
    var startScreen = true
    var myMutableString = NSMutableAttributedString()
    var muteActive = false
    
    

    // IB Outlets
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var overLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var colorView: ColorView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var shakeLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var roundScoreLabel: UILabel!
    
    // IB Actions
    @IBAction func mute(_ sender: UIButton) {
        if !muteActive {
        audioPlayer.volume = 0
        successSound.volume = 0
        failureSound.volume = 0
        muteActive = true
        sender.setTitle("Unmute Sound", for: .normal)
        }
        else {
            audioPlayer.volume = 0.5
            successSound.volume = 1
            failureSound.volume = 1
            muteActive = false
            sender.setTitle("Mute Sound", for: .normal)
        }
    }
    @IBAction func startButtonPressed(_ sender: UIButton) {
        startButton.isHidden = true
        detectShake = true
        shakeLabel.isHidden = true
        gameRound = 1
        score = 0
        instructionsLabel.isHidden = true
        scoreLabel.text = "Score: 0"
        roundLabel.text = "Round: 1"
        roundScoreLabel.isHidden = true
        shakeLabel.isHidden = false
        gameTitle.isHidden = true
        gameLabel.isHidden = true
        overLabel.isHidden = true
        if !audioPlayer.isPlaying {
            audioPlayer.play()
            audioPlayer.numberOfLoops = -1
            audioPlayer.volume = 0.5
        }
        
    }
    
    func setTimer(time: Double) {
        // UPDATETIMER FIRES EVERY MILLISECOND
        if !roundInProgress {
        timer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        colorView.timer = time
        colorView.maxArcLength = time
        }
    }
    
    func updateTimer() {
        
    
        if colorView.timer > 0 {
            // DECREMENT TIMER
            colorView.timer -= 0.00818
            timerLabel.text = String(Double(Int(colorView.timer*10))/10)
            roundScore = Int(1000 * (colorView.timer/colorView.maxArcLength))
            roundScoreLabel.text = "\(roundScore)"
        } else {
            // IF TIMER REACHES ZERO:
            //      ALERT THE USER
            //      SET GAMEINPROGRESS TO FALSE
            timer.invalidate()
            gameInProgress = false
            roundInProgress = false
            startButton.isHidden = false
            detectShake = false
            roundScoreLabel.isHidden = true
//            let alert = UIAlertController(title: "You lose!", message: "You ran out of time.", preferredStyle: UIAlertControllerStyle.alert);
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil));
//            self.present(alert, animated: true, completion: nil);
            startButton.setTitle("Start Over?", for: .normal)
            gameLabel.isHidden = false
            gameLabel.textColor = timerLabel.textColor
            overLabel.isHidden = false
            overLabel.textColor = timerLabel.textColor
            startButton.backgroundColor = timerLabel.textColor
            failureSound.play()
            audioPlayer.stop()
            startScreen = true
            timerLabel.text = " "
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }

    
    override func viewDidLoad() {
        colorArr = [(5, 0, 5), (5, 0, 4), (6, 0, 4), (6, 0, 3), (6, 1, 3), (6, 1, 2), (5, 1, 2), (6, 2, 2), (6, 2, 1), (6, 3, 1), (6, 3, 0), (7, 3, 1), (7, 2, 1), (7, 2, 2), (7, 1, 2), (7, 1, 3), (5, 0, 3), (4, 0, 3), (4, 1, 3), (4, 1, 2), (4, 2, 1), (4, 3, 1), (4, 3, 0), (4, 4, 0), (5, 4, 0), (5, 5, 0), (6, 5, 0), (6, 6, 0), (7, 6, 0), (7, 6, 1), (8, 6, 1), (8, 7, 1), (8, 7, 2), (8, 8, 2), (8, 8, 3), (8, 9, 3), (7, 9, 3), (7, 10, 4), (6, 10, 4), (6, 10, 5), (5, 10, 5), (5, 10, 6), (4, 10, 6), (3, 10, 6), (3, 9, 6), (3, 9, 7), (2, 9, 7), (2, 8, 6), (1, 8, 6), (1, 7, 6), (0, 7, 6), (0, 7, 5), (0, 6, 5), (0, 6, 4), (0, 6, 3), (0, 5, 3), (1, 5, 3), (1, 5, 2), (1, 4, 2), (2, 4, 1), (3, 4, 1), (3, 3, 1), (5, 2, 1), (5, 1, 3), (3, 1, 2), (3, 2, 2), (2, 3, 1), (2, 5, 1), (2, 6, 1), (3, 6, 1), (3, 7, 1), (4, 8, 1), (4, 9, 2), (5, 9, 2), (5, 9, 3), (6, 10, 3), (5, 10, 7), (4, 10, 7), (4, 9, 7), (2, 8, 7), (1, 8, 7), (1, 7, 7), (0, 6, 6), (0, 5, 5), (0, 5, 4), (1, 4, 3), (2, 4, 2), (3, 1, 3), (3, 2, 1), (3, 4, 0), (4, 5, 0), (5, 6, 0), (6, 7, 0), (6, 7, 1), (7, 7, 1), (9, 8, 3), (9, 8, 4), (9, 8, 5), (9, 8, 6), (9, 8, 7), (8, 8, 7), (8, 8, 8), (7, 8, 9), (6, 8, 9), (5, 8, 9), (5, 7, 9), (4, 7, 9), (3, 7, 9), (3, 6, 9), (2, 6, 9), (2, 5, 9), (1, 4, 8), (1, 3, 8), (1, 3, 7), (1, 3, 6), (1, 3, 5), (1, 3, 4), (1, 2, 3), (2, 2, 3), (2, 1, 3), (4, 0, 4), (4, 0, 5), (3, 0, 5), (3, 0, 4), (3, 1, 4), (7, 0, 4), (7, 1, 4), (5, 3, 1), (2, 3, 2), (1, 3, 2), (2, 2, 2), (5, 0, 6), (4, 0, 6), (4, 0, 7), (4, 1, 7), (3, 1, 7), (2, 1, 7), (2, 1, 6), (1, 2, 5), (1, 2, 4), (6, 4, 0), (7, 5, 0), (7, 5, 1), (8, 6, 2), (9, 7, 2), (9, 7, 3), (9, 7, 4), (10, 7, 4), (10, 7, 3), (5, 7, 0), (4, 6, 0), (3, 6, 0), (3, 5, 0), (3, 5, 1), (4, 9, 3), (4, 10, 3), (4, 10, 4), (4, 10, 5), (4, 9, 8), (4, 8, 8), (4, 8, 9), (3, 8, 9), (3, 8, 8), (3, 9, 8), (3, 9, 5), (3, 9, 4), (3, 9, 3), (3, 9, 2), (4, 8, 2), (4, 7, 1), (4, 7, 0), (5, 3, 0), (5, 1, 1), (6, 0, 5), (6, 0, 6), (5, 7, 1), (5, 10, 3), (5, 10, 4), (3, 10, 5), (3, 10, 4), (3, 10, 3), (5, 8, 1), (5, 9, 1), (0, 4, 3), (0, 4, 4), (0, 4, 5), (0, 4, 6), (0, 4, 7), (1, 4, 7), (1, 5, 7), (0, 5, 7), (0, 5, 6), (1, 5, 1), (7, 4, 0), (7, 4, 1), (8, 4, 1), (8, 5, 1), (9, 5, 2), (9, 5, 3), (10, 5, 3), (10, 5, 4), (10, 5, 5), (10, 5, 6), (9, 6, 2), (9, 5, 1), (1, 5, 8), (1, 6, 8), (8, 3, 1), (8, 3, 2), (9, 3, 2), (9, 4, 2), (9, 4, 3), (10, 4, 3), (10, 4, 4), (10, 4, 5), (10, 4, 6), (10, 5, 7), (10, 6, 7), (6, 8, 1), (7, 8, 1), (7, 8, 2), (8, 9, 4), (8, 9, 5), (8, 9, 6), (8, 9, 7), (7, 9, 7), (6, 9, 7), (6, 9, 8), (5, 9, 8), (0, 3, 5), (0, 3, 4), (4, 2, 2), (2, 9, 6), (1, 3, 3), (3, 0, 6), (3, 1, 6), (2, 1, 5), (1, 1, 5), (6, 8, 2), (6, 9, 2), (1, 8, 5), (1, 7, 5), (7, 0, 5), (8, 1, 3), (8, 2, 3), (8, 2, 2), (8, 1, 4), (7, 1, 5), (7, 9, 2), (6, 9, 3), (5, 9, 7), (7, 7, 9), (8, 7, 9), (8, 6, 9), (9, 5, 9), (9, 5, 8), (9, 4, 8), (9, 3, 8), (9, 3, 7), (9, 2, 7), (8, 2, 6), (8, 1, 6), (8, 1, 5), (7, 9, 4), (7, 10, 5), (7, 9, 6), (9, 7, 7), (9, 6, 7), (9, 5, 7), (10, 4, 7), (9, 4, 7), (9, 3, 6), (9, 2, 6), (9, 7, 6), (10, 7, 6), (10, 6, 6), (10, 6, 5), (10, 6, 4), (2, 2, 4), (2, 1, 4), (8, 2, 4), (9, 2, 4), (9, 2, 3), (9, 3, 3), (9, 3, 4), (10, 3, 4), (10, 3, 5), (7, 7, 0), (2, 8, 8), (2, 7, 8), (1, 7, 8), (1, 6, 7), (1, 2, 6), (7, 0, 6), (7, 1, 6), (3, 8, 1), (3, 8, 2), (2, 8, 2), (8, 8, 4), (9, 9, 5), (9, 9, 6), (8, 8, 6), (3, 1, 5), (4, 1, 8), (5, 1, 8), (6, 1, 8), (7, 1, 8), (7, 1, 7), (8, 1, 7), (8, 2, 7), (9, 2, 5), (2, 9, 3), (2, 9, 4), (2, 9, 5), (1, 9, 5), (1, 8, 4), (1, 8, 3), (2, 8, 3), (2, 7, 2), (2, 7, 1), (6, 7, 9), (7, 6, 9), (8, 5, 9), (8, 4, 9), (7, 8, 8), (8, 6, 8), (9, 6, 8), (9, 3, 5), (7, 10, 6), (6, 10, 7), (0, 6, 7), (2, 7, 9), (5, 7, 10), (5, 6, 10), (5, 5, 10), (5, 4, 10), (4, 4, 10), (3, 4, 10), (3, 5, 10), (3, 5, 9), (3, 6, 10), (3, 4, 9), (2, 4, 9), (2, 3, 9), (3, 3, 9), (3, 2, 9), (3, 2, 8), (3, 1, 8), (6, 10, 6), (5, 3, 10), (5, 3, 9), (4, 2, 9), (5, 1, 7), (5, 0, 7), (4, 7, 10), (4, 3, 10), (4, 3, 9), (5, 2, 9), (6, 2, 9), (6, 1, 7), (6, 0, 7), (5, 9, 9), (6, 7, 10), (6, 6, 10), (7, 6, 10), (7, 5, 10), (7, 4, 10), (7, 4, 9), (7, 3, 9), (7, 2, 9), (6, 2, 8), (7, 5, 9), (8, 3, 9), (8, 2, 8), (7, 2, 8), (2, 6, 2), (1, 7, 2), (4, 6, 10), (6, 3, 10), (6, 3, 9), (3, 7, 0), (4, 5, 10), (2, 3, 8), (2, 2, 8), (2, 4, 8), (1, 6, 2), (7, 9, 8), (2, 2, 7), (1, 2, 7), (8, 7, 8), (6, 5, 10), (8, 4, 8), (10, 3, 6), (7, 9, 5), (1, 6, 3), (4, 2, 8), (7, 3, 0), (8, 3, 8), (1, 5, 9), (2, 6, 8), (0, 3, 6), (8, 4, 2), (2, 2, 6), (10, 7, 5), (9, 7, 5), (1, 7, 3), (10, 6, 3), (9, 6, 3), (9, 7, 8), (6, 4, 10), (7, 0, 3), (1, 4, 1), (6, 1, 1), (0, 7, 4), (1, 7, 4), (5, 1, 9), (2, 8, 4), (9, 1, 5), (1, 9, 4), (3, 3, 0), (6, 8, 8)]

        super.viewDidLoad()
        timerLabel.text = " "
        startButton.isHidden = false
        detectShake = false
        instructionsLabel.isHidden = false
        scoreLabel.text = "Score: 0"
        roundLabel.text = "Round: 1"
        roundScoreLabel.isHidden = true
        shakeLabel.isHidden = true
        startButton.layer.cornerRadius = 20
        randColor = colorArr[Int(arc4random_uniform(UInt32(colorArr.count)))]
        contrast = contrastTupe(tupe: randColor)
        startButton.backgroundColor = changeColor(tupe: contrast)
        view.backgroundColor = changeColor(tupe: randColor)
        colorView.backgroundColor = changeColor(tupe: randColor)
        colorView.timerColor = changeColor(tupe: contrast)
        scoreLabel.isHidden = true
        roundLabel.isHidden = true
        gameLabel.isHidden = true
        overLabel.isHidden = true
        gameTitle.attributedText = differentColorLetters(str: gameTitle.text, colorTupe: randColor)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource:"musicloop", ofType:"wav")!))
        }
        catch {
            print(error)
        }
        do {
            successSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource:"successSound", ofType:"mp3")!))
        }
        catch {
            print(error)
        }
        do {
            failureSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource:"gameover", ofType:"mp3")!))
        }
        catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //###################
    //User Motion Section
    //###################
    
    override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let moc = managedObjectContext
    let colorsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Color")
    
    do {
    var _: [Color]
    let fetchedColors = try moc.fetch(colorsFetch) as! [Color]
    print(fetchedColors.count)
    } catch {
    fatalError("Failed to fetch employees: \(error)")
    }
//        print(Double((randColor.0))/10)
        motionManager = CMMotionManager()
        if let manager = motionManager {
            
            if manager.isDeviceMotionAvailable {
                manager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {
                    (data: CMDeviceMotion?, error: Error?) in
                    if let mydata = data {
                        
                        let xcolors = round((mydata.gravity.x + 1)*5)
                        let zcolors = round((mydata.gravity.z + 1)*5)
                        let ycolors = round((mydata.gravity.y + 1)*5)
                        
                        // IF COLOR IS MATCHED:
                        if  abs(Int(xcolors)-self.randColor.0) < 1 && abs(Int(zcolors)-self.randColor.1) < 1 &&
                            abs(Int(ycolors)-self.randColor.2) < 1 {
                            //      --STOP THE TIMER--
                            self.timer.invalidate()
                            //      --INCREMENT ROUND--
                            if self.roundInProgress {
                                self.roundInProgress = false
                                self.gameRound += 1
                                self.roundLabel.text = "Round: " + String(self.gameRound)
                            //      --INCREMENT SCORE--
//                                let quartile = self.colorView.maxArcLength / 4
//                                if self.colorView.timer > (quartile * 3) {
//                                    self.score += 200
//                                } else if self.colorView.timer > (quartile * 2) {
//                                    self.score += 150
//                                } else if self.colorView.timer > quartile {
//                                    self.score += 125
//                                } else {
//                                    self.score += 100
//                                }
                                self.score += self.roundScore
                                self.scoreLabel.text = "Score: \(self.score)"
                            //      --SHOW READY BUTTON--
                                self.detectShake = true
                                self.shakeLabel.isHidden = false
                                self.matched = true
                                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                                if self.successSound.isPlaying {
                                    self.successSound.stop()
                                    self.successSound.play()
                                }
                                else {
                                    self.successSound.play()
                                }
                                
                                self.roundScoreLabel.isHidden = true
                            }
                        }
                        
                        if self.detectShake && ((mydata.userAcceleration.x > 2 || mydata.userAcceleration.x < -2) || (mydata.userAcceleration.y > 2 || mydata.userAcceleration.y < -2) || (mydata.userAcceleration.z > 2 || mydata.userAcceleration.z < -2)) {
                            var roundTime = Double()
                            if self.gameRound <= 12 {
                                roundTime = 60/Double(self.gameRound)
                            }
                            else if self.gameRound > 12 {
                                roundTime = Double(5)
                            }
                            self.setTimer(time: roundTime)
                            self.randColor = self.colorArr[Int(arc4random_uniform(UInt32(self.colorArr.count)))]
                            self.contrast = self.contrastTupe(tupe: self.randColor)
                            self.colorView.outlineColor = self.changeColor(tupe: self.contrast)
                            self.colorView.timerColor = self.changeColor(tupe: self.randColor)
                            self.matched = false
                            self.roundInProgress = true
                            self.roundScore = 1000
                            self.roundScoreLabel.text = "\(self.roundScore)"
                            self.roundScoreLabel.isHidden = false
                            self.detectShake = false
                            self.shakeLabel.isHidden = true
                            self.startScreen = false
                            self.roundScoreLabel.isHidden = false
                            self.scoreLabel.isHidden = false
                            self.roundLabel.isHidden = false
                        }
                        
                        if self.matched == true {
                            self.contrast = self.contrastTupe(tupe: self.randColor)
                            self.view.backgroundColor = self.changeColor(tupe: self.randColor)
                            self.colorView.backgroundColor = self.changeColor(tupe: self.randColor)
                            self.timerLabel.textColor = self.changeColor(tupe:self.contrast)
                        }
                        else if self.startScreen {
                            
                        }
                        else {
                            self.contrast = self.contrastTupe(tupe: (Int(xcolors),Int(zcolors),Int(ycolors)))
                            self.view.backgroundColor = self.changeColor(tupe: (Int(xcolors), Int(zcolors), Int(ycolors)))
                            self.colorView.backgroundColor = self.changeColor(tupe: (Int(xcolors), Int(zcolors), Int(ycolors)))
                            self.timerLabel.textColor = self.changeColor(tupe: self.contrast)
                            self.startButton.backgroundColor = self.changeColor(tupe: self.contrast)
                        }
                        
                        
                        
//                        self.rgb.text = "X: \(randColor.0) Y: \(randColor.1) Z: \(randColor.2)"
//                        self.rgb.textColor = UIColor(red: CGFloat(Double((randColor.0))/10), green: CGFloat(Double((randColor.1))/10), blue: CGFloat(Double((randColor.2))/10), alpha: 1)
                    }
                    if let myerror = error {
                        print("myerror", myerror)
                        manager.stopDeviceMotionUpdates()
                    }
                })
            }
            else {
                print("no motion")
            }
        }
        else {
            print("No motion manager")
        }
    }
    func contrastTupe(tupe: (Int,Int,Int)) -> (Int,Int,Int) {
        let tupArr = [tupe.0,tupe.1,tupe.2]
        var max = tupe.0
        var min = tupe.0
        var total = 0
        for i in tupArr {
            if i > max {
                max = i
            }
            if i < min {
                min = i
            }
        }
        total = max + min
        return (total-tupe.0,total-tupe.1,total-tupe.2)
        
    }
    
    func changeColor(tupe: (Int,Int,Int)) -> UIColor {
        let myItem = UIColor(red: CGFloat(Double(tupe.0)/10), green: CGFloat(Double(tupe.1)/10), blue: CGFloat(Double(tupe.2)/10), alpha: 1)
//        print(tupe)
        return myItem
    }
    
    func differentColorLetters(str: String?, colorTupe: (Int,Int,Int)) -> NSMutableAttributedString {
        if let myStr = str {
            myMutableString = NSMutableAttributedString(string: myStr)
            for i in 0..<myStr.characters.count {
                let randColor = pickUniqueColor(tupe: colorTupe)
                let myColor = changeColor(tupe: randColor)
                myMutableString.addAttribute(NSForegroundColorAttributeName, value: myColor, range: NSRange(location:i,length:1))
            }
            return myMutableString
        }
        else {
            print("empty string")
        }
        return NSMutableAttributedString(string: "error")
    }
    
    func pickUniqueColor(tupe: (Int,Int,Int)) -> (Int,Int,Int) {
        var pickedColor = colorArr[Int(arc4random_uniform(UInt32(colorArr.count)))]
        while pickedColor == tupe {
            pickedColor = colorArr[Int(arc4random_uniform(UInt32(colorArr.count)))]
        }
        return pickedColor
    }
}


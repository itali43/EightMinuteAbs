//
//  ViewController.swift
//  EightMinuteAbs
//
//  Created by Elliott Williams on 7/22/18.
//  Copyright © 2018 AgrippaApps. All rights reserved.
//


/// color
// background: 19191C
// button: 32343B
// text: DFDEE3

import UIKit
import AudioToolbox
import UICircularProgressRing

class ViewController: UIViewController {
    let greenColor = UIColor(red: 102/255, green: 255/255, blue: 102/255, alpha: 1.0)
    var exercises = [
    "Flutter Kicks",
    "Bicycle Sit Ups",
    "Mountain Climbers",
    "Crunches",
    "Leg Lifters",
    "Supermans",
    "Leg Spreaders",
    "Side Planks",
    "Russian Twist",
    "Sideways Crunches",
    "Russian Twist",
    "Sit Ups",
    "Wipers",
    "Scissors",
    "Toe Taps",
    "Russian Twists",
    "Lying Knee Raises",
    "Figure 8's",
    "Pike Ups (V-Ups)",
    "Side Plank Raises",
    "Reverse Plank",
    "Alt. Sides Superman",
    "Donkey Kicks",
    ]
    var roundCounter = 0
    var seconds = 481
    var secondsPast: CGFloat = 0.0
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //  always keeping the screen showing (without the screen sleeping from no touching)
    }
    //TO DO--====
    // ADD background mode
    //and/or
    func runTimer() {
        isTimerRunning = true
        UIApplication.shared.isIdleTimerDisabled = true // doesn't go to sleep
        pauseBTN.isEnabled = true // can press pause
        skipExerciseBTN.isEnabled = true // can press skip
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            roundNumberLabel.text = "0"
            roundCounter = 0
            
            //Send alert to indicate "time's up!"
        } else {
            seconds -= 1
            secondsPast = CGFloat(abs(481 - seconds))
            progressRing.value = secondsPast

            
            timerCountdownLabel.text = timeString(time: TimeInterval(seconds))
        }

        if seconds % 60 == 0 {
//            update exercise
            soundAirHorn()
            buzz()

            roundCounter += 1
            roundNumberLabel.text = "\(roundCounter)"
            randomExerciseUpdate()

        }
    }

    func randomExerciseUpdate() { // should add a non repeating feature later
        print("update exercise")
        if roundCounter != 8 {
            let randomIndex = Int(arc4random_uniform(UInt32(exercises.count)))
            exerciseLabel.text = exercises[randomIndex]

        } else {print("ending")}
}
    func soundAirHorn() {
        Sound.play(file: "AirHorn.wav")
    }
    func buzz() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

    }
    @IBOutlet weak var progressRing: UICircularProgressRing!
    
    @IBOutlet weak var pauseBTN: UIButton!
    @IBAction func pauseAction(_ sender: Any) {
            if self.resumeTapped == false {
                timer.invalidate()
                self.resumeTapped = true
                self.pauseBTN.setTitle("Go", for: .normal)
                

            } else {
                runTimer()
                self.resumeTapped = false
                self.pauseBTN.setTitle("Pause", for: .normal)


            }
    }
    
    @IBOutlet weak var skipExerciseBTN: UIButton!
    @IBAction func skipExerciseAction(_ sender: Any) {
        randomExerciseUpdate()
    }
    
    @IBOutlet weak var timerCountdownLabel: UILabel!
    
    @IBOutlet weak var roundNumberLabel: UILabel!
    
    @IBOutlet weak var exerciseLabel: UILabel!
    
    
    @IBOutlet weak var stopWatchImage: UIImageView!
    
    
    @IBOutlet weak var startBTN: UIButton!
    @IBAction func startAction(_ sender: Any) {
        if isTimerRunning == false {
            runTimer()
            self.startBTN.isEnabled = false


        }

    }
    
    @IBOutlet weak var resetBTN: UIButton!
    
    @IBAction func resetAction(_ sender: Any) {
        timer.invalidate()
        seconds = 481
        roundCounter = 0
        secondsPast = CGFloat(abs(481 - seconds))
        progressRing.value = secondsPast

        roundNumberLabel.text = "\(roundCounter)"
        isTimerRunning = false
        UIApplication.shared.isIdleTimerDisabled = false

        updateTimer()
        pauseBTN.isEnabled = false
        skipExerciseBTN.isEnabled = false
        self.startBTN.isEnabled = true



    }

    func timeString(time:TimeInterval) -> String {
//        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let format = "%02i:%02i"
        return String(format: format, minutes, seconds)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = skipExerciseBTN.titleLabel?.text{
            skipExerciseBTN.setAttributedTitle(title.getUnderLineAttributedText(), for: .normal)
        }

        
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarStyle = .default

        // Progress ring
        progressRing.maxValue = 481
        progressRing.minValue = 0
        progressRing.gradientColors = [greenColor,  .white]
        progressRing.gradientColorLocations = [0.5, 1.0]
        progressRing.gradientStartPosition = .left
        progressRing.gradientEndPosition = .bottomRight
        progressRing.ringStyle = .gradient
        progressRing.innerCapStyle = .butt
        progressRing.innerRingColor = .white
        pauseBTN.isEnabled = false
        skipExerciseBTN.isEnabled = false
        UIApplication.shared.isIdleTimerDisabled = false


        self.startBTN.isEnabled = true
        
        pauseBTN.layer.cornerRadius = 0.5 * pauseBTN.bounds.size.width
        pauseBTN.clipsToBounds = true
        
        startBTN.layer.cornerRadius = 0.5 * startBTN.bounds.size.width
        startBTN.clipsToBounds = true
        
        resetBTN.layer.cornerRadius = 0.5 * resetBTN.bounds.size.width
        resetBTN.clipsToBounds = true



        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


}


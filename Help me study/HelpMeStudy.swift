//
//  HelpMeStudy.swift
//  Help me study
//
//  Created by Nadav Baruch on 12-01-17.
//  Copyright © 2017 Nadav Baruch. All rights reserved.
//

import UIKit
import AVFoundation

class HelpMeStudy: UIViewController {
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var studyTimeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioPlayer = AVAudioPlayer()
    var minutes: Int = 30
    var studyMinutes: Int = 0
    var pauseMinutes: Int = 0
    var studyTimer = Timer()
    var breakTimer = Timer()
    var rounds = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false

        UIView.animate(withDuration: 0.0) {
            self.timeLeftLabel.alpha = 0
            self.timeLeftLabel.isUserInteractionEnabled = false
            
            self.pauseButton.alpha = 0
            self.pauseButton.isUserInteractionEnabled = false
            
            self.stopButton.alpha = 0
            self.stopButton.isUserInteractionEnabled = false
            
            do
            {
                let audioPath = Bundle.main.path(forResource: "CL", ofType: ".mp3")
                try self.audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
            }
            catch
            {
                //ERROR
            }

        }
    }
    
    @IBAction func slider(_ sender: UISlider) {
        minutes = Int(sender.value)
        if minutes == 0{
            studyTimeLabel.text = "30" + " minutes"
            timeLeftLabel.text = "30"
        }
        else{
            studyTimeLabel.text = String(minutes) + " minutes"
            timeLeftLabel.text = String(minutes)
        }
        
    }

    func studyCounter(){
        studyMinutes -= 1
//        if minutes/10 != 0{
//            timeLeftLabel.isHidden = true
//        }
//        else{
//            timeLeftLabel.isHidden = false
//        }
        timeLeftLabel.text = String(studyMinutes)
        print("studycounter")
        
        if studyMinutes == 0{
            studyTimer.invalidate()
            audioPlayer.play()
            startPause()
            rounds += 1
        }
    }
    func startPause(){
        pauseMinutes = 5
        breakTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(HelpMeStudy.breakCounter), userInfo: nil, repeats: true)
        print("startpause")
    }

    func breakCounter(){
        pauseMinutes -= 1
        timeLeftLabel.text = String(pauseMinutes)
        print("breakcounter")
        if pauseMinutes == 0{
            breakTimer.invalidate()
            audioPlayer.stop()
            startStudy(confirmButton)
        }
    }
    
//    func musicCounter(){
//        minutes = Int(0.1)
//        minutes -= 1
//        timeLeftLabel.text = String(minutes)
//        
//        if minutes == 0{
//            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(HelpMeStudy.studyCounter), userInfo: nil, repeats: true)
//        }
//    }
    
    @IBAction func startStudy(_ sender: Any) {
        studyTimer.invalidate()
        breakTimer.invalidate()
        self.studyMinutes = minutes
        print("startstudy")
        studyTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(HelpMeStudy.studyCounter), userInfo: nil, repeats: true)
        UIView.animate(withDuration: 0.4) {
            self.confirmButton.alpha = 0
            self.confirmButton.isUserInteractionEnabled = false
            
            self.questionTextView.alpha = 0
            self.questionTextView.isUserInteractionEnabled = false
            
            self.studyTimeLabel.alpha = 0
            self.studyTimeLabel.isUserInteractionEnabled = false
            
            self.timeSlider.alpha = 0
            self.timeSlider.isUserInteractionEnabled = false
            
            self.timeLeftLabel.alpha = 1
            self.timeLeftLabel.isUserInteractionEnabled = true
            
            self.pauseButton.alpha = 1
            self.pauseButton.isUserInteractionEnabled = true
            
            self.stopButton.alpha = 1
            self.stopButton.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func pauseStudy(_ sender: Any) {
        if pauseButton.currentTitle == "Pause"{
            studyTimer.invalidate()
            breakTimer.invalidate()
            pauseButton.setTitle("Play", for: .normal)
        }
        if pauseButton.currentTitle == "Play"{
            startStudy(confirmButton)
            pauseButton.setTitle("Pause", for: .normal)
        }
    }
    
    @IBAction func stopStudy(_ sender: Any) {
        studyTimer.invalidate()
        breakTimer.invalidate()
        audioPlayer.stop()
        minutes = 30
        timeSlider.setValue(30, animated: true)
        studyTimeLabel.text = "30"

        let vc = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "navVC")
        self.present(vc, animated: true, completion: nil)
    }
    
}

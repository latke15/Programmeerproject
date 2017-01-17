//
//  StudyTimer.swift
//  Help me study
//
//  Created by Nadav Baruch on 12-01-17.
//  Copyright © 2017 Nadav Baruch. All rights reserved.
//

import UIKit

class StudyTimer: UIViewController {
    
    // User defaults
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var minutes: Int = 0
    var timer = Timer()
    var rounds: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        minutes = defaults.integer(forKey:"minutes")

    }
    @IBAction func startTimer(_ sender: Any) {
    }
    @IBAction func stopTimer(_ sender: Any) {
        timer.invalidate()
        let vc = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "menuVC")
        self.present(vc, animated: true, completion: nil)
    }
    
    func studyCounter(){
        minutes -= 1
        if minutes/10 != 0{
            timeLeftLabel.isHidden = true
        }
        timeLeftLabel.text = String(minutes)
        
        if minutes == 0{
            timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(StudyTimer.breakCounter), userInfo: nil, repeats: false)
            rounds += 1
        }
    }
    func breakCounter(){
        minutes = 5
        minutes -= 1
        timeLeftLabel.text = String(minutes)
        
        if minutes == 0{
            timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(StudyTimer.studyCounter), userInfo: nil, repeats: false)
        }
    }
}

//
//  HelpMeStudy.swift
//  Help me study
//
//  Created by Nadav Baruch on 12-01-17.
//  Copyright © 2017 Nadav Baruch. All rights reserved.
//

import UIKit

class HelpMeStudy: UIViewController {
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var studyTimeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    
    // User defaults
    let defaults = UserDefaults.standard
    
    var minutes: Int = 0
    var bla: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func slider(_ sender: UISlider) {
        minutes = Int(sender.value)
        studyTimeLabel.text = String(minutes) + " minutes"
        self.defaults.set(minutes, forKey:"minutes")

    }
    @IBAction func startStudy(_ sender: Any) {
        _ = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(StudyTimer.studyCounter), userInfo: nil, repeats: false)
        self.defaults.set(minutes, forKey:"minutes")
        print(bla = defaults.integer(forKey:"minutes"))
    }
}

//
//  HelpMeStudy.swift
//  Help me study
//
//  Created by Nadav Baruch on 12-01-17.
//  Copyright © 2017 Nadav Baruch. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

class HelpMeStudy: UIViewController {
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var studyTimeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var minutes: Int = 30
    var studyMinutes: Int = 0
    var points: Int = 0
    var pauseMinutes: Int = 0
    var studyTimer = Timer()
    var breakTimer = Timer()
    var friends = [Friend]()
    var ref: FIRDatabaseReference!
    
    func notificationBreak(triggerDate: Date){
        // notification, source: https://github.com/kenechilearnscode/UserNotificationsTutorial
        let content = UILocalNotification()
        content.alertTitle = "Hey"
        content.alertBody = "Your study time is over. Enjoy your break!"
        content.fireDate = triggerDate as Date
        UIApplication.shared.scheduleLocalNotification(content)
    }
    func notificationStudy(triggerDate: Date){
        // notification, source: https://github.com/kenechilearnscode/UserNotificationsTutorial
        let content = UILocalNotification()
        content.alertTitle = "Hey"
        content.alertBody = "Your break is over. Go study!"
        content.fireDate = triggerDate as Date
        UIApplication.shared.scheduleLocalNotification(content)
    }
    
    func notificationStudy(){
        // notification, source: https://github.com/kenechilearnscode/UserNotificationsTutorial
        let content = UNMutableNotificationContent()
        content.title = "Hey"
        content.body = "Your break is over. Go back to study!"
        content.badge = 1
        content.sound = UNNotificationSound.init(named: "AirHorn.mp3")

        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let requestIdentifier = "Breakalert"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        UNUserNotificationCenter.current().delegate = self

        UIView.animate(withDuration: 0.0) {
            self.timeLeftLabel.alpha = 0
            self.timeLeftLabel.isUserInteractionEnabled = false
            
            self.pauseButton.alpha = 0
            self.pauseButton.isUserInteractionEnabled = false
            
            self.stopButton.alpha = 0
            self.stopButton.isUserInteractionEnabled = false
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
    
    func updatePoints(points: Int) {
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").child(uid).child("points").observeSingleEvent(of: .value, with: { snapshot in
            
            if var point = snapshot.value as? Int {
                point += 1
                ref.child("users").child(uid).child("points").setValue(point)
            }
        })
    }

    func studyCounter(){
    
        studyMinutes -= 1
        timeLeftLabel.text = String(studyMinutes)
        points += 1
        print(points)
        updatePoints(points: points)
        print("studycounter")
        if studyMinutes == 0{
//            notificationBreak()
            studyTimer.invalidate()
            startPause()
        }
    }
    func startPause(){
        pauseMinutes = 5
        var startDate = NSDate()
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .second, value: pauseMinutes, to: startDate as Date)
        breakTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(HelpMeStudy.breakCounter), userInfo: nil, repeats: true)
        notificationStudy(triggerDate: date!)
        print("startpause")
    }
    
    func breakCounter(){
        pauseMinutes -= 1
        timeLeftLabel.text = String(pauseMinutes)
        print("breakcounter")
        if pauseMinutes == 0{
            //notificationStudy()
            breakTimer.invalidate()
            startStudy(confirmButton)
        }
    }
    
    @IBAction func startStudy(_ sender: Any) {
        studyTimer.invalidate()
        breakTimer.invalidate()
        self.studyMinutes = minutes
        print("startstudy")
        
        var startDate = NSDate()
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .second, value: self.studyMinutes, to: startDate as Date)
        notificationBreak(triggerDate: date!)
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
        minutes = 30
        timeSlider.setValue(30, animated: true)
        studyTimeLabel.text = "30"

        let vc = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "navVC")
        self.present(vc, animated: true, completion: nil)
    }
    
}
extension HelpMeStudy: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // some other way of handling notification
        completionHandler([.alert, .sound])
    }
}


//
//  HelpMeStudy.swift
//  Help me study
//
//  This viewcontroller contains the timer for the application. The user can set the time he
//  wants to study and start studying. When he touches the stop button the timer will stop.
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
    @IBOutlet weak var stopButton: UIButton!
    
    var minutes: Int = 30
    var bigBreakMinutes: Int = 30
    var studyMinutes: Int = 0
    var points: Int = 0
    var pauseMinutes: Int = 5
    var studyTimer = Timer()
    var breakTimer = Timer()
    var friends = [Friend]()
    var ref: FIRDatabaseReference!
    
    // source: https://github.com/kenechilearnscode/UserNotificationsTutorial
    func notificationStudy(){
        let content = UNMutableNotificationContent()
        content.title = "Hey!"
        content.body = "Your break is over. Go back to study!"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let requestIdentifier = "Breakalert"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
        })
    }
    
    // source: https://github.com/kenechilearnscode/UserNotificationsTutorial
    func notificationBreak(){
        let content = UNMutableNotificationContent()
        content.title = "Hey!"
        content.body = "Your break started. Enjoy your Break!"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
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
        updatePoints(points: points)
        if studyMinutes == 0{
            notificationBreak()
            studyTimer.invalidate()
            startPause()
        }
    }
    func startPause(){
        pauseMinutes = 5
        breakTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(HelpMeStudy.breakCounter), userInfo: nil, repeats: true)
    }
    
    func breakCounter(){
        pauseMinutes -= 1
        timeLeftLabel.text = String(pauseMinutes)
        if pauseMinutes == 0{
            notificationStudy()
            breakTimer.invalidate()
            studyTimer.invalidate()
            startStudy(confirmButton)
        }
    }
    
    @IBAction func startStudy(_ sender: Any) {
        studyTimer.invalidate()
        breakTimer.invalidate()
        self.studyMinutes = minutes
        
        studyTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(HelpMeStudy.studyCounter), userInfo: nil, repeats: true)
        
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
            
            self.stopButton.alpha = 1
            self.stopButton.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func stopStudy(_ sender: Any) {
        studyTimer.invalidate()
        breakTimer.invalidate()
        minutes = 30
        timeSlider.setValue(30, animated: true)
        studyTimeLabel.text = "30"
        
        // source: http://stackoverflow.com/questions/25511945/swift-alert-view-ios8-with-ok-and-cancel-button-which-button-tapped
        let refreshAlert = UIAlertController(title: "Warning!", message: "Winners never quit, quitters never win.", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            let vc = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "navVC")
            self.present(vc, animated: true, completion: nil)
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
}
extension HelpMeStudy: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // some other way of handling notification
        completionHandler([.alert, .sound])
    }
}


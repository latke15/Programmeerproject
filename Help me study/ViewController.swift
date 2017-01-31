//
//  ViewController.swift
//  Help me study
//
//  Created by Nadav Baruch on 31-01-17.
//  Copyright © 2017 Nadav Baruch. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    var minutes = 1
    
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func buttonClicked(_ sender: Any) {
        var startDate = NSDate()
        print(startDate)
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: minutes, to: startDate as Date)
        print(startDate)
        print(date!)
        notificationBreak(triggerDate: date!)
    }
    
    func notificationBreak(triggerDate: Date){
        // notification, source: https://github.com/kenechilearnscode/UserNotificationsTutorial
        let content = UILocalNotification()
        content.alertTitle = "Hey"
        content.alertBody = "Your study time is over. Enjoy your break!"
        content.fireDate = triggerDate as Date
//        content.sound = UNNotificationSound.init(named: "CL.mp3")
        UIApplication.shared.scheduleLocalNotification(content)
    }
}

extension Date {
    func add(minutes: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .minute, value: minutes, to: self)!
    }
}

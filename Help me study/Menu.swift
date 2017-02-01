//
//  Menu.swift
//  Help me study
//
//  Created by Nadav Baruch on 12-01-17.
//  Copyright © 2017 Nadav Baruch. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

class Menu: UIViewController {
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    @IBOutlet weak var friendsButton: UIButton!
    @IBOutlet weak var rankingsButton: UIButton!
    @IBOutlet weak var helpMeStudyButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = FIRAuth.auth()?.currentUser
        nameLabel.text = "Welcome, " + (user?.displayName)! + "!"
        
        // Source: https://www.hackingwithswift.com/example-code/system/how-to-detect-when-your-app-moves-to-the-background
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try! FIRAuth.auth()!.signOut()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func appMovedToBackground() {
        print("App moved to background!")
        notificationExit()
    }
    
    // Source: https://github.com/kenechilearnscode/UserNotificationsTutorial
    func notificationExit(){
        let content = UNMutableNotificationContent()
        content.title = "Warning!"
        content.body = "You're leaving the app which means your timer won't continue running!"
        content.badge = 0

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let requestIdentifier = "Breakalert"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
        })
    }
}

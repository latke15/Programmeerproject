//
//  Menu.swift
//  Help me study
//
//  Created by Nadav Baruch on 12-01-17.
//  Copyright © 2017 Nadav Baruch. All rights reserved.
//

import UIKit
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

        // Do any additional setup after loading the view.
    }
    @IBAction func logOut(_ sender: Any) {
        do {
            try! FIRAuth.auth()!.signOut()
        } catch let error {
            print(error.localizedDescription)
        }
    }

}

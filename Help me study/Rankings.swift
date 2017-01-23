//
//  Rankings.swift
//  Help me study
//
//  Created by Nadav Baruch on 12-01-17.
//  Copyright © 2017 Nadav Baruch. All rights reserved.
//

import UIKit
import Firebase

class Rankings: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var rankingTableView: UITableView!
    
    var friends = [Friend]()


    override func viewDidLoad() {
        super.viewDidLoad()
//        retrieveUsers()

        // Do any additional setup after loading the view.
    }
    
//    func retrieveUsers() {
//        let ref = FIRDatabase.database().reference()
//        let uid = FIRAuth.auth()!.currentUser!.uid
//        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
//            let users = snapshot.value as! [String: AnyObject]
//            self.friends.removeAll()
//            for (_, value) in users {
//                if let uid = value["uid"] as? String {
//                    ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
//                        let userToShow = Friend()
//                        if let firstName = value["First name"] as? String, let lastName = value["Last name"] as? String, let imagePath = value["urlToImage"] as? String {
//                            userToShow.name = firstName + lastName
//                            userToShow.imagePath = imagePath
//                            userToShow.userID = uid
//                            self.friends.append(userToShow)
//                        }
//                    }
//                }
//            }
//            self.rankingTableView.reloadData()
//        })
//        ref.removeAllObservers()
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rankingTableView.dequeueReusableCell(withIdentifier: "friendRankingCell", for: indexPath) as? FriendRankingCell
        
        cell?.nameLabel.text = self.friends[indexPath.row].name
        cell?.userID = self.friends[indexPath.row].userID
        cell?.profilePicture.downloadImage(from: self.friends[indexPath.row].imagePath)        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count ?? 0
    }
   
}

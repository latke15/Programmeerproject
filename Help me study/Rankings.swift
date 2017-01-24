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
        followingUsers()
        // Do any additional setup after loading the view.
    }
    
    func followingUsers() {
        let ref = FIRDatabase.database().reference()
        var uid = FIRAuth.auth()!.currentUser!.uid
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            if let following = snapshot.value as? [String: AnyObject] {
                for(_, value) in following {
                    let fid = value as! String
                    let userToShow = Friend()
                    userToShow.userID = fid
                    ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in                                                  let user = snapshot.value as! [String : AnyObject]
                        self.friends.removeAll()
                        if fid == value as? String {
                            for (_, value) in user {
                                let uid = value["uid"] as? String
                                if fid == uid {
                                    DispatchQueue.main.async {                                                                                  if let fullName = value["First name"] as? String, let imagePath = value["urlToImage"] as? String {                                             userToShow.name = fullName
                                        userToShow.imagePath = imagePath
                                        self.friends.append(userToShow)
                                        }
                                        self.rankingTableView.reloadData()
                                    }
                                }
                            }
                        }
                    })
                }
            }
        })
    }


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

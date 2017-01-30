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
                ref.child("users").queryOrdered(byChild: "points").observeSingleEvent(of: .value, with: { snapshot in                                                  let user = snapshot.value as! [String : AnyObject]
                        self.friends.removeAll()
                        if fid == value as? String {
                            for (_, value) in user {
                                let uid = value["uid"] as? String
                                if fid == uid {
                                    DispatchQueue.main.async {                                                                                  if let fullName = value["Full name"] as? String, let imagePath = value["urlToImage"] as? String, let points = value["points"] {                                             userToShow.name = fullName
                                        userToShow.imagePath = imagePath
                                        userToShow.points = points as! Int!
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
    // source: http://stackoverflow.com/questions/24130026/swift-how-to-sort-array-of-custom-objects-by-property-value
    func sorterForFileIDASC(this:Friend, that:Friend) -> Bool {
        return this.points > that.points
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rankingTableView.dequeueReusableCell(withIdentifier: "friendRankingCell", for: indexPath) as? FriendRankingCell
        
        friends.sort(by: sorterForFileIDASC)

        cell?.nameLabel.text = self.friends[indexPath.row].name
        cell?.userID = self.friends[indexPath.row].userID
        cell?.profilePicture.downloadImage(from: self.friends[indexPath.row].imagePath)
        cell?.studiedMinutesLabel.text = String(self.friends[indexPath.row].points)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count ?? 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.friends[indexPath.row].name)
        rankingTableView.deselectRow(at: indexPath, animated: true)
    }

   
}

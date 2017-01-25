//
//  Friends.swift
//  Help me study
//
//  Created by Nadav Baruch on 12-01-17.
//  Copyright © 2017 Nadav Baruch. All rights reserved.
//

import UIKit
import Firebase

class Friends: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {
    @IBOutlet weak var friendsTableView: UITableView!
    var friends = [Friend]()
    var filteredFriends = [Friend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveUsers()
    }
    
    func retrieveUsers() {
        let ref = FIRDatabase.database().reference()
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            let users = snapshot.value as! [String: AnyObject]
            self.friends.removeAll()
            for (_, value) in users {
                if let uid = value["uid"] as? String {
                    if uid != FIRAuth.auth()!.currentUser!.uid {
                        let userToShow = Friend()
                        if let fullName = value["Full name"] as? String, let imagePath = value["urlToImage"] as? String {
                            userToShow.name = fullName
                            userToShow.imagePath = imagePath
                            userToShow.userID = uid
                            self.friends.append(userToShow)
                        }
                    }
                }
            }
            self.friendsTableView.reloadData()
        })
        ref.removeAllObservers()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "Title"){
        self.filteredFriends = self.friends.filter({( friend: Friend) -> Bool in
            
            let categoryMatch = (scope == "Title")
            let stringMatch = friend.name.contains(searchText)
            
            return categoryMatch && (stringMatch != nil)
        })
    }
    
    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearch searchString: String?) -> Bool {
        self.filterContentForSearchText(searchText: searchString!, scope: "Title")
        return true
    }
    
    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(searchText: (self.searchDisplayController!.searchBar.text)!, scope: "Title")
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsTableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as? FriendsCell
        
        var friend: Friend
        
        if (friendsTableView == self.searchDisplayController?.searchResultsTableView){
            friend = self.filteredFriends[indexPath.row]
        }
        else{
            friend = self.friends[indexPath.row]
        }
        cell?.nameLabel.text = self.friends[indexPath.row].name
        cell?.userID = self.friends[indexPath.row].userID
        cell?.profilePicture.downloadImage(from: self.friends[indexPath.row].imagePath)
        checkFollowing(indexPath: indexPath)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (friendsTableView == self.searchDisplayController?.searchResultsTableView){
            return filteredFriends.count
        }
        else{
            return friends.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let key = ref.child("users").childByAutoId().key
        
        var isFollowing = false
        
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (ke, value) in following {
                    if value as! String == self.friends[indexPath.row].userID {
                        isFollowing = true
                        
                        ref.child("users").child(uid).child("following/\(ke)").removeValue()
                        ref.child("users").child(self.friends[indexPath.row].userID).child("followers/\(ke)").removeValue()
                        
                        self.friendsTableView.cellForRow(at: indexPath)?.accessoryType = .none
                    }
                }
            }
            if !isFollowing {
                let following = ["following/\(key)" : self.friends[indexPath.row].userID]
                let followers = ["followers/\(key)" : uid]
                
                ref.child("users").child(uid).updateChildValues(following)
                ref.child("users").child(self.friends[indexPath.row].userID).updateChildValues(followers)
                
                self.friendsTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
        })
        ref.removeAllObservers()
        friendsTableView.deselectRow(at: indexPath, animated: true)
        
    }

    func checkFollowing(indexPath: IndexPath) {
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (_, value) in following {
                    if value as! String == self.friends[indexPath.row].userID {
                        self.friendsTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    }
                }
            }
        })
        ref.removeAllObservers()
    }
}

extension UIImageView {
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}

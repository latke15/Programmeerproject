//
//  Friends.swift
//  Help me study
//
//  Created by Nadav Baruch on 12-01-17.
//  Copyright © 2017 Nadav Baruch. All rights reserved.
//

import UIKit
import Firebase

class Friends: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var friends = [Friend]()
    var filteredFriends = [Friend]()
    
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveUsers()
        searchBar.delegate = self
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsTableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as? FriendsCell
        
        if isSearching == true{
            cell?.nameLabel.text = filteredFriends[indexPath.row].name
            cell?.userID = filteredFriends[indexPath.row].userID
            cell?.profilePicture.downloadImage(from: filteredFriends[indexPath.row].imagePath)
        }
        else{
            cell?.nameLabel.text = friends[indexPath.row].name
            cell?.userID = friends[indexPath.row].userID
            cell?.profilePicture.downloadImage(from: friends[indexPath.row].imagePath)
        }
        
        checkFollowing(indexPath: indexPath, isSearching: isSearching)

        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredFriends.count: friends.count
    }
    
    // This method updates filteredData based on the text in the Search Box
    // Source: https://github.com/codepath/ios_guides/wiki/Search-Bar-Guide
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredFriends = searchText.isEmpty ? friends : friends.filter({(friendsString: Friend) -> Bool in
            return friendsString.name.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        friendsTableView.reloadData()
    }
    
    // Source: https://github.com/codepath/ios_guides/wiki/Search-Bar-Guide
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
        self.searchBar.showsCancelButton = true
    }
    
    // Source: https://github.com/codepath/ios_guides/wiki/Search-Bar-Guide
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.friendsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let array = isSearching ? self.filteredFriends : self.friends
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let key = ref.child("users").childByAutoId().key
        
        var isFollowing = false
        
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (ke, value) in following {
                    if value as! String == array[indexPath.row].userID {
                        isFollowing = true
                        
                        ref.child("users").child(uid).child("following/\(ke)").removeValue()
                        ref.child("users").child(array[indexPath.row].userID).child("followers/\(ke)").removeValue()
                        
                        self.friendsTableView.cellForRow(at: indexPath)?.accessoryType = .none
                    }
                }
            }
            if !isFollowing {
                let following = ["following/\(key)" : array[indexPath.row].userID]
                let followers = ["followers/\(key)" : uid]
                
                ref.child("users").child(uid).updateChildValues(following)
                ref.child("users").child(array[indexPath.row].userID).updateChildValues(followers)
                
                self.friendsTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
        })
        ref.removeAllObservers()
        friendsTableView.deselectRow(at: indexPath, animated: true)
    }

    func checkFollowing(indexPath: IndexPath, isSearching: Bool) {
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (_, value) in following {
                    
                    let array = isSearching ? self.filteredFriends : self.friends
                    if value as! String == array[indexPath.row].userID {
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

//
//  Friends.swift
//  Help me study
//
//  Created by Nadav Baruch on 12-01-17.
//  Copyright © 2017 Nadav Baruch. All rights reserved.
//

import UIKit
import Firebase

class Friends: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let searchController = UISearchController(searchResultsController: nil)

    
    // Setup the Search Controller
    //searchController.searchResultsUpdater = self
    //searchController.searchBar.delegate = self
    //definesPresentationContext = true
    //searchController.dimsBackgroundDuringPresentation = false
    
    var friends = [Friend]()
    //var filteredCandies = [Friend]()


    //override func viewWillAppear(_ animated: Bool) {
      //  clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        //super.viewWillAppear(animated)
    //}
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsTableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as? FriendsCell
        
        //if searchController.isActive && searchController.searchBar.text != "" {
          //  friends = filteredUsers[indexPath.row]
        //} else {
          //  friends = friends[indexPath.row]
        //}

        
        cell?.nameLabel.text = self.friends[indexPath.row].name
        cell?.userID = self.friends[indexPath.row].userID
        cell?.profilePicture.downloadImage(from: self.friends[indexPath.row].imagePath)
        checkFollowing(indexPath: indexPath)

        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if searchController.isActive && searchController.searchBar.text != "" {
          //  return filteredCandies.count
        //}
        return friends.count ?? 0
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
    
    //func filterContentForSearchText(_ searchText: String) {
      //  filteredUsers = friends.filter({( friend : Friends) -> Bool in
        //    let categoryMatch = (scope == "All") || (candy.category == scope)
          //  return categoryMatch && candy.name.lowercased().contains(searchText.lowercased())
        //})
        //friendsTableView.reloadData()
    //}
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

//extension Friends: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
  //  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange /selectedScope: Int) {
        //filterContentForSearchText(searchBar.text!)
  //  }
//}

//extension Friends: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
  //  func updateSearchResults(for searchController: UISearchController) {
    //    let searchBar = searchController.searchBar
      //  filterContentForSearchText(searchController.searchBar.text!)
    //}
//}

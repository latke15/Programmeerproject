//
//  FriendRankingCell.swift
//  Help me study
//
//  This cell is used for the FriendsTableView.
//  
//  Created by Nadav Baruch on 23-01-17.
//  Copyright © 2017 Nadav Baruch. All rights reserved.
//

import UIKit

class FriendRankingCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var studiedMinutesLabel: UILabel!

    var userID: String!


}

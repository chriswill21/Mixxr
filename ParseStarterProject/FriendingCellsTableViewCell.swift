//
//  FriendingCellsTableViewCell.swift
//  ParseStarterProject-Swift
//
//  Created by Christien Williams on 6/27/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class FriendingCellsTableViewCell: UITableViewCell {

    @IBOutlet var addButton: UIButton!
    @IBAction func addFriends(_ sender: UIButton) {
    }
    
    @IBAction func otherButtonAction(_ sender: UIButton) {
    }
    
    @IBOutlet var otherButtonOutlet: UIButton!
    @IBOutlet var fullName: UILabel!

    @IBOutlet var phoneNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  EventCell.swift
//  ParseStarterProject-Swift
//
//  Created by Christien Williams on 6/15/17.
//  Copyright © 2017 Parse. All rights reserved.
//



import UIKit

class EventCell: UITableViewCell {
    

    @IBOutlet var caption: UILabel!
    
    @IBOutlet var date: UILabel!
    
    @IBOutlet var name: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // Initialization code
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    
    }
    
}

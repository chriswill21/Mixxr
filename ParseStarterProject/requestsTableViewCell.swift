//
//  requestsTableViewCell.swift
//  ParseStarterProject-Swift
//
//  Created by Christien Williams on 6/23/17.
//  Copyright © 2017 Parse. All rights reserved.
//

/*
import UIKit

class requestsTableViewCell: UITableViewCell, UITableViewDelegate {
    
    
    @IBOutlet weak var textLabel2: UILabel! //displays name of user who has sent friend request
    
    @IBAction func acceptRequest(sender: AnyObject) {
        
        //query below adds the user who friend requested the current user to the current user's accepted friends array
        var query = PFQuery(className:"friends")
        query.whereKey("username", equalTo:PFUser.currentUser().username)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects.count) records.")
                // Do something with the found objects
                for object in objects {
                    object.addUniqueObject(self.textLabel2?.text, forKey: "accepted")
                    object.saveInBackgroundWithTarget(nil, selector: nil)
                }
                
            } else {
                // Log details of the failure
            }
        }
        
        //query below adds the current user to the accepted friends array of the user who friend requested
        var query2 = PFQuery(className:"friends")
        query2.whereKey("username", equalTo: self.textLabel2?.text)
        query2.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects.count) records.")
                // Do something with the found objects
                for object in objects {
                    object.addUniqueObject(PFUser.currentUser().username, forKey: "accepted")
                    object.saveInBackgroundWithTarget(nil, selector: nil)
                }
                
            } else {
                // Log details of the failure
            }
        }
        //query below deletes the user who sent the friend request from the current user's requests array
        var query3 = PFQuery(className:"friends")
        query3.whereKey("username", equalTo:PFUser.currentUser().username)
        query3.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects.count) records.")
                // Do something with the found objects
                for object in objects {
                    object.removeObject(self.textLabel2?.text, forKey: "requests")
                    object.saveInBackgroundWithTarget(nil, selector: nil)
                }
                
            } else {
                // Log details of the failure
            }
        }
        
    }
    
    @IBAction func rejectRequest(sender: AnyObject) {
        
        //query below simply deletes the user who sent the friend request from the current user's requests array
        var query = PFQuery(className:"friends")
        query.whereKey("username", equalTo:PFUser.currentUser().username)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects.count) records.")
                // Do something with the found objects
                for object in objects {
                    object.removeObject(self.textLabel2?.text, forKey: "requests")
                    object.saveInBackgroundWithTarget(nil, selector: nil)
                }
                
            } else {
                // Log details of the failure
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
*/

//
//  EventPage.swift
//  ParseStarterProject-Swift
//
//  Created by Nwanacho Nwana on 7/2/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class EventPage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var organizationLabel: UILabel!
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDetailsLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ChatTableView: UITableView!
    
    var messages: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChatTableView.delegate = self
        ChatTableView.dataSource = self
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        
        ChatTableView.rowHeight = UITableViewAutomaticDimension
        ChatTableView.estimatedRowHeight = 50
        
        ChatTableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressSend(_ sender: Any) {
        let chatMessage = PFObject(className: "")//get class name; VERY IMPORTANT
        
        //Store the text of the text field in a key called "text"
        chatMessage["text"] = messageTextField.text ?? ""
        chatMessage["user"] = PFUser.current()
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                print(chatMessage["text"])
                self.messageTextField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }//close saveInBackground
    }//close didPressSend
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ChatTableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        let message = messages![indexPath.row]
        let text = message["text"]
        cell.chatCellLabel.text = text as! String
        if let user = message["user"] as? PFUser {
            //user found, update username label w username
            cell.usernameLabel.text = user.username
        } else {
            //no user found
            cell.usernameLabel.text = "🤖"
        }
        
        return cell
    }
    
    func onTimer() {
        // Add code to be run periodically
        
        var query = PFQuery(className: "") //class name
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        query.findObjectsInBackground { (retrievedMessages: [PFObject]?, error: Error?) in
            self.messages = retrievedMessages
            self.ChatTableView.reloadData()
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//
//  UserViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Christien Williams on 5/25/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class UserViewController: UIViewController {
    
    let user = PFUser.current()
    
    @IBOutlet var usersName: UILabel!
    @IBAction func addFriends(_ sender: Any) {
        performSegue(withIdentifier: "friendsSegue", sender: self)
    }
    @IBAction func logout(_ sender: Any) {
        PFUser.logOutInBackground()
        //self.dismiss(animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        if PFUser.current() == nil{
            performSegue(withIdentifier: "logoutSegue", sender: self)
        }
        print("logged out")
        
    } 
    override func viewDidLoad() {
        super.viewDidLoad()
        //let first = user?["firstname"] as! String
        //let last = user?["lastname"] as! String
        //usersName.text = first + " " + last
        usersName.text = user?.email

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

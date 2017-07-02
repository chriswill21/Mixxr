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

    @IBAction func logout(_ sender: Any) {
        PFUser.logOut()
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "login")
        self.present(vc, animated: true, completion: nil)
        
        
        /*if PFUser.current() == nil{
            performSegue(withIdentifier: "logoutSegue", sender: self)
        }
        print("logged out")*/
        
    }
    
    
    
    /*@IBAction func logOutAction(sender: AnyObject){
        
        // Send a request to log out a user
        PFUser.logOut()
        
        dispatchas.main.asynchronously(execute: { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login") as! UIViewController
            self.present(viewController, animated: true, completion: nil)
        })
        
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*let first = user?["firstname"] as! String
        let last = user?["lastname"] as! String
        usersName.text = first + " " + last*/
        

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

//
//  SignUpViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Christien Williams on 6/16/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    
    let user = PFUser.current()
    
    @IBOutlet var firstname: UITextField!
    
    @IBOutlet var lastname: UITextField!
    
    @IBOutlet var phonenumber: UITextField!
    
    func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func mixxbutton(_ sender: Any) {
        
        if firstname.text == "" || lastname.text == "" || phonenumber.text == ""{
            
            createAlert(title: "Something went wrong", message: "Please ensure that you type in your name and provided a valid phone number.")
        
        } else {
            
            user?["firstname"] = firstname.text!
            user?["lastname"] = lastname.text!
            user?["phonenumber"] = phonenumber.text
            
            user?.saveInBackground { (success, error) in
                if error != nil{
                    self.createAlert(title: "Something went wrongs", message: "Please ensure that you type in your name and provided a valid phone number.")
                } else {
                    self.performSegue(withIdentifier: "infoToProfile", sender: self)
                }
            }
            
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

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

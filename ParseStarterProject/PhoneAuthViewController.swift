//
//  PhoneAuthViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Christien Williams on 7/9/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class PhoneAuthViewController: UIViewController {
    
    @IBOutlet var authCodeText: UITextField!
    
    @IBAction func authenticateButton(_ sender: Any) {
        let verificationID = ""
        if let verificationCode = authCodeText.text{
            
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID,
                verificationCode: verificationCode)
            
            
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    // ...
                    return
                }
                // User is signed in
                // ...
                let a = 0
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

//
//  LogInViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Christien Williams on 7/9/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Firebase
import Parse
import FirebaseAuth


class LogInViewController: UIViewController {
    var activityIndicator = UIActivityIndicatorView()
    
    func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet var authCodeText: UITextField!
    
    @IBOutlet var phoneNumber: UITextField!

    @IBOutlet var fullName: UITextField!
    
    @IBOutlet var smsSentToLabel: UILabel!
    
    @IBAction func sendButton(_ sender: Any) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber.text!) { (verificationID, error) in
            if let error = error {
                self.createAlert(title: "Uh-oh", message: error.localizedDescription)
                //self.showMessagePrompt(error.localizedDescription)
                //return
            }
            // Sign in using the verificationID and the code sent to the user
            // ...
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            //let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
            
            self.performSegue(withIdentifier: "PhoneAuthSegue", sender: self)
            
            self.smsSentToLabel.text = "Enter authentication code sent to " + self.phoneNumber.text! + "..."
            
        }
        
    }
    
    
    @IBAction func phoneLogInButton(_ sender: Any) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //set verifcation ID to saved ID
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        if let verificationCode = self.authCodeText.text{
            
            //authenticate
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID!,
                verificationCode: verificationCode)
            
            //sign in
            Auth.auth().signIn(with: credential) { (user, error) in
                
                //self.activityIndicator.stopAnimating()
                //UIApplication.shared.endIgnoringInteractionEvents()
                
                if let error = error {
                    // ...
                    self.createAlert(title: "Login error", message: "Ensure that you have entered the correct Authentication Code")
                    //return
                    
                    
                } else { // Sign User in using token and parse
                    
                    
                    //get token
                    user?.getToken(completion: { (token, error) in
                        if let error = error {
                            // ...
                            //ERROR
                            //return
                        } else {
                            //use user token with completion to SIGN UP and then LOG INTO parse backend
                            let uniqueUserToken = token
                            let user = PFUser()
                            user.username = self.fullName.text
                            user.password = uniqueUserToken
                            user["phonenumber"] = self.phoneNumber!.text
                            
                            user.signUpInBackground(block: { (success, error) in
                                
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                
                                if error != nil{
                                    var displayErrorMessage = "Please try again"
                                    
                                    /*if let errorMessage = error?.userInfo["error"] as? String{
                                     displayErrorMessage = errorMessage
                                     }*/
                                    self.createAlert(title: "Oops", message: "Account already exists for this username")
                                } else {
                                    print("User signed up")
                                    //self.performSegue(withIdentifier: "SignUpSegue", sender: self)
                        
                                    
                                }
                            })
                            
                            
                        }
                        
                    })
                    
                }
                    
                }
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil{
            //self.performSegue(withIdentifier: "showUserProfile", sender: self)
            
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

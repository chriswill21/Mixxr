/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signUpMode = true
    var activityIndicator = UIActivityIndicatorView()
    

    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var signUpOrLogin: UIButton!

    
    func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func signUpOrLogin(_ sender: Any) {
        //when users press the sign in button
        
        if emailTextField.text == "" || passwordTextField.text == ""{
            
            createAlert(title: "Uh-oh", message: "Please enter an email and password")
            
            
        } else {
            
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if signUpMode{
                //Sign up
                
                let user = PFUser()
                user.username = self.emailTextField.text
                user.email = self.emailTextField.text
                user.password = self.passwordTextField.text
                
                
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
                        self.performSegue(withIdentifier: "SignUpSegue", sender: self)

                        
                        
                    }
                })
                
            } else {
                //log in
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil{
                        
                        var displayErrorMessage = "Please try again"
                        
                        /*if let errorMessage = error?.userInfo["error"] as? String{
                         displayErrorMessage = errorMessage
                         }*/
                        
                        self.createAlert(title: "Login error", message: "Invalid username/password")
                        
                    } else {
                        print("Logged in!")
                        

                        self.performSegue(withIdentifier: "showUserProfile", sender: self)
                    }
                    
                })
                
            }
            
        }
        
    }
    
    
    @IBOutlet var messageLabel: UILabel!
   

    
    @IBOutlet var changeSignupModeButton: UIButton!
    
    @IBAction func changeSignupMode(_ sender: Any) {
        if signUpMode{
            // Change to login mode
            signUpOrLogin.setTitle("Log in", for: [])
            
            changeSignupModeButton.setTitle("Sign up", for: [])
            messageLabel.text = "Don't have an account?"
            
            signUpMode = false
        } else{
            // Change to sign up mode
            signUpOrLogin.setTitle("Sign up", for: [])
            
            changeSignupModeButton.setTitle("Log in", for: [])
            messageLabel.text = "Already have an account?"
            
            signUpMode = true
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil{
            self.performSegue(withIdentifier: "showUserProfile", sender: self)

        }
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

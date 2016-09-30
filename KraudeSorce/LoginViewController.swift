//
//  LoginViewController.swift
//  KraudeSorce
//
//  Created by Yash Dalal on 9/15/16.
//  Copyright © 2016 Yash Dalal. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    let loginSuccessful = "loginSuccessful"
    
    
    
    @IBAction func authenticate(sender: AnyObject) {
        FIRAuth.auth()?.signInWithEmail(email.text!, password: password.text!){ (user, error) in
            if error == nil {
                NSLog("Authentication Successful \(user?.email!)")
                self.performSegueWithIdentifier(self.loginSuccessful, sender: nil)
            } else {
                NSLog("Authentication failed with error \(error)")
            }
        }
    }
    
    @IBAction func signUp(sender: AnyObject) {
        performSegueWithIdentifier("signUpPage", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
//            if let user = user {
//                // User is signed in.
//            } else {
//                // No user is signed in.
//            }
//        }
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

//
//  SignUpViewController.swift
//  KraudeSorce
//
//  Created by Yash Dalal on 9/20/16.
//  Copyright © 2016 Yash Dalal. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var retypedPasswordField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        let email = emailField.text!
        let password = passwordField.text!
        let retypePassword = retypedPasswordField.text!
        
        if email != "" && password != "" && retypePassword != ""{
            FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: {(user: FIRUser?, error) in
                if (error != nil){
                    self.errorMessage.text = "Something went wrong while creating your account. Try again."
                } else {
                    FIRAuth.auth()?.signInWithEmail(email, password: password){ (user, error) in
                        if error == nil {
                            self.performSegueWithIdentifier("loginSuccessful", sender: nil)
                        } else {
                            self.performSegueWithIdentifier("loginPage", sender: nil)
                        }
                    }
                    NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: "uid")
                }
            })
        } else {
            errorMessage.text = "Don't forget to enter your email address, and your password."
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

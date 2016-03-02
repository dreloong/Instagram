//
//  LoginViewController.swift
//  Instagram
//
//  Created by Xiaofei Long on 3/1/16.
//  Copyright © 2016 dreloong. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Actions

    @IBAction func onLoginButtonTouchUp(sender: AnyObject) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""

        PFUser.logInWithUsernameInBackground(
            username,
            password: password
        ) { (user: PFUser?, error: NSError?) -> Void in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.performSegueWithIdentifier("login", sender: nil)
            }
        }
    }

    @IBAction func onSignupButtonTouchUp(sender: AnyObject) {
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text

        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.performSegueWithIdentifier("login", sender: nil)
            }
        }
    }

}

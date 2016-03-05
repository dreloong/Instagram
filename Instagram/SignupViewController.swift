//
//  SignupViewController.swift
//  Instagram
//
//  Created by Xiaofei Long on 3/5/16.
//  Copyright © 2016 dreloong. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse

class SignupViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Actions

    @IBAction func onSignupButtonTouchUp(sender: AnyObject) {
        let progressHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHud.labelFont = UIFont.systemFontOfSize(14)

        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        newUser.email = emailField.text

        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                print(error.localizedDescription)
            } else {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.performSegueWithIdentifier("signup", sender: nil)
            }
        }
    }
}

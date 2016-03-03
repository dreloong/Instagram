//
//  HomeViewController.swift
//  Instagram
//
//  Created by Xiaofei Long on 3/2/16.
//  Copyright © 2016 dreloong. All rights reserved.
//

import UIKit
import Parse

let userDidLogoutNotification = "userDidLogoutNotification"

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Actions

    @IBAction func onLogoutButtonTouchUp(sender: AnyObject) {
        PFUser.logOut()
        NSNotificationCenter.defaultCenter().postNotificationName(
            userDidLogoutNotification,
            object: nil
        )
    }

}

//
//  AppDelegate.swift
//  Instagram
//
//  Created by Xiaofei Long on 3/1/16.
//  Copyright © 2016 dreloong. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?
    ) -> Bool {
        Parse.initializeWithConfiguration(
            ParseClientConfiguration(block: { (config: ParseMutableClientConfiguration) -> Void in
                config.applicationId = "Instagram"
                config.clientKey = "o8hB2RP19tY525X6Or09hS36xL19wt1G"
                config.server = "https://dreloong-instagram.herokuapp.com/parse"
            })
        )
        return true
    }

}

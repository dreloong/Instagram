//
//  Post.swift
//  Instagram
//
//  Created by Xiaofei Long on 3/2/16.
//  Copyright © 2016 dreloong. All rights reserved.
//

import Foundation
import Parse
import UIKit

class Post {

    class func postUserImage(image: UIImage?, caption: String?, completion: PFBooleanResultBlock?) {
        let post = PFObject(className: "Post")

        post["author"] = PFUser.currentUser()
        post["caption"] = caption
        post["commentsCount"] = 0
        post["likesCount"] = 0
        post["media"] = Util.getPFFileFromImage(image)

        post.saveInBackgroundWithBlock(completion)
    }
}

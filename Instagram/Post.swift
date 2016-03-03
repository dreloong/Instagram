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
        post["media"] = getPFFileFromImage(image)

        post.saveInBackgroundWithBlock(completion)
    }

    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        if let image = image {
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }

}

//
//  PostTableViewHeaderFooterView.swift
//  Instagram
//
//  Created by Xiaofei Long on 3/4/16.
//  Copyright © 2016 dreloong. All rights reserved.
//

import UIKit
import Parse
import NSDateMinimalTimeAgo

class PostTableViewHeaderFooterView: UITableViewHeaderFooterView {

    var post: PFObject! {
        didSet {
            let author = post.objectForKey("author")!

            let viewHeight: CGFloat = 50
            let viewWidth: CGFloat = 320
            let margin: CGFloat = 12

            // Profile Image
            let imageSize = viewHeight - 2 * margin
            let profileImageView = UIImageView(frame: CGRect(
                x: margin,
                y: margin,
                width: imageSize,
                height: imageSize
            ))
            profileImageView.layer.cornerRadius = imageSize / 2
            profileImageView.clipsToBounds = true
            if let imageFile = author.objectForKey("imageFile") as? PFFile {
                imageFile.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                    if let data = data {
                        profileImageView.image = UIImage(data: data)
                    } else {
                        print(error?.localizedDescription)
                    }
                })
            } else {
                profileImageView.image = UIImage(named: "ProfileImage")
            }
            self.addSubview(profileImageView)

            // User Name
            let userNameLabelText = author.username!! as NSString
            let userNameLabelFont = UIFont.systemFontOfSize(14)
            let userNameLabelSize =
                userNameLabelText.sizeWithAttributes([NSFontAttributeName: userNameLabelFont])
            let userNameLabel = UILabel(frame: CGRect(
                x: viewHeight,
                y: (viewHeight - userNameLabelSize.height) / 2,
                width: userNameLabelSize.width,
                height: userNameLabelSize.height
            ))
            userNameLabel.textAlignment = .Left
            userNameLabel.font = userNameLabelFont
            userNameLabel.text = author.username
            self.addSubview(userNameLabel)

            // Created At
            let createdAtLabelText = (post.createdAt?.timeAgo())! as NSString
            let createdAtLabelFont = UIFont.systemFontOfSize(14)
            let createdAtLabelSize =
                createdAtLabelText.sizeWithAttributes([NSFontAttributeName: createdAtLabelFont])
            let createdAtLabel = UILabel(frame: CGRect(
                x: viewWidth - margin - createdAtLabelSize.width,
                y: (viewHeight - createdAtLabelSize.height) / 2,
                width: createdAtLabelSize.width,
                height: createdAtLabelSize.height
            ))
            createdAtLabel.textAlignment = .Right
            createdAtLabel.font = UIFont.systemFontOfSize(14)
            createdAtLabel.text = post.createdAt?.timeAgo()
            self.addSubview(createdAtLabel)
        }
    }

}

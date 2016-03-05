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

@objc protocol PostTableViewHeaderFooterViewDelegate {

    optional func postTableViewHeaderFooterView(
        postTableViewHeaderFooterView: PostTableViewHeaderFooterView,
        didTapProfileImageViewOfPost post: PFObject
    )

    optional func postTableViewHeaderFooterView(
        postTableViewHeaderFooterView: PostTableViewHeaderFooterView,
        didTapUsernameLabelOfPost post: PFObject
    )
}

class PostTableViewHeaderFooterView: UITableViewHeaderFooterView {

    weak var delegate: PostTableViewHeaderFooterViewDelegate?

    var author: PFUser!
    var profileImageView: UIImageView!
    var usernameLabel: UILabel!
    var createdAtLabel: UILabel!

    let viewHeight: CGFloat = 50
    let viewWidth: CGFloat = 320
    let margin: CGFloat = 12

    var post: PFObject! {
        didSet {
            author = post.objectForKey("author") as! PFUser
            updateProfileImageView()
            updateUsernameLabel()
            updateCreatedAtLabel()
        }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    func initView() {
        initProfileImageView()
        initUsernameLabel()
        initCreatedAtLabel()

        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(createdAtLabel)
    }

    func initProfileImageView() {
        let imageSize = viewHeight - 2 * margin
        profileImageView = UIImageView(frame: CGRect(
            x: margin,
            y: margin,
            width: imageSize,
            height: imageSize
        ))
        profileImageView.layer.cornerRadius = imageSize / 2
        profileImageView.clipsToBounds = true

        let tapGesture = UITapGestureRecognizer(target: self, action: "onProfileImageViewTap:")
        profileImageView.userInteractionEnabled =  true
        profileImageView.addGestureRecognizer(tapGesture)
    }

    func initUsernameLabel() {
        usernameLabel = UILabel()
        usernameLabel.textAlignment = .Left
        usernameLabel.font = UIFont.systemFontOfSize(14)

        let tapGesture = UITapGestureRecognizer(target: self, action: "onUsernameLabelTap:")
        usernameLabel.userInteractionEnabled =  true
        usernameLabel.addGestureRecognizer(tapGesture)
    }

    func initCreatedAtLabel() {
        createdAtLabel = UILabel()
        createdAtLabel.textAlignment = .Right
        createdAtLabel.font = UIFont.systemFontOfSize(14)
    }

    func updateProfileImageView() {
        if let imageFile = author.objectForKey("imageFile") as? PFFile {
            imageFile.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    self.profileImageView.image = UIImage(data: data)
                } else {
                    print(error?.localizedDescription)
                }
            })
        } else {
            profileImageView.image = UIImage(named: "ProfileImage")
        }
    }

    func updateUsernameLabel() {
        let usernameLabelText = author.username! as NSString
        let usernameLabelSize =
            usernameLabelText.sizeWithAttributes([NSFontAttributeName: usernameLabel.font])
        usernameLabel.frame = CGRect(
            x: viewHeight,
            y: (viewHeight - usernameLabelSize.height) / 2,
            width: usernameLabelSize.width,
            height: usernameLabelSize.height
        )
        usernameLabel.text = author.username
    }

    func updateCreatedAtLabel() {
        let createdAtLabelText = (post.createdAt?.timeAgo())! as NSString
        let createdAtLabelSize =
            createdAtLabelText.sizeWithAttributes([NSFontAttributeName: createdAtLabel.font])
        createdAtLabel.frame = CGRect(
            x: viewWidth - margin - createdAtLabelSize.width,
            y: (viewHeight - createdAtLabelSize.height) / 2,
            width: createdAtLabelSize.width,
            height: createdAtLabelSize.height
        )
        createdAtLabel.text = post.createdAt?.timeAgo()
    }

    func onProfileImageViewTap(recognizer: UITapGestureRecognizer) {
        delegate?.postTableViewHeaderFooterView?(self, didTapProfileImageViewOfPost: post)
    }

    func onUsernameLabelTap(recognizer: UITapGestureRecognizer) {
        delegate?.postTableViewHeaderFooterView?(self, didTapUsernameLabelOfPost: post)
    }
}

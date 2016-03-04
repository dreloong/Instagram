//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by Xiaofei Long on 3/3/16.
//  Copyright © 2016 dreloong. All rights reserved.
//

import UIKit
import Parse

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!

    var post: PFObject! {
        didSet {
            captionLabel.text = post.objectForKey("caption") as? String

            let likesCount = post.objectForKey("likesCount") as! Int
            likesCountLabel.text = "Likes: \(likesCount)"

            let media = post.objectForKey("media") as! PFFile
            media.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    self.postImageView.image = UIImage(data: data)
                } else {
                    print(error?.localizedDescription)
                }
            })
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

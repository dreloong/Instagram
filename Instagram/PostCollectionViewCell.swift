//
//  PostCollectionViewCell.swift
//  Instagram
//
//  Created by Xiaofei Long on 3/4/16.
//  Copyright © 2016 dreloong. All rights reserved.
//

import UIKit
import Parse

class PostCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var postImageView: UIImageView!

    var post: PFObject! {
        didSet {
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
}

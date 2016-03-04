//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Xiaofei Long on 3/4/16.
//  Copyright © 2016 dreloong. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    var posts = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()

        usernameLabel.text = PFUser.currentUser()?.username

        profileImageView.userInteractionEnabled = true
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        if let imageFile = PFUser.currentUser()?.objectForKey("imageFile") as? PFFile {
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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        fetchPosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Actions

    @IBAction func onProfileImageViewTap(sender: AnyObject) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }

    // MARK: - Helpers

    func fetchPosts() {
        let query = PFQuery(className: "Post")
        query.whereKey("author", equalTo: PFUser.currentUser()!)
        query.orderByDescending("createdAt")
        query.includeKey("author")

        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if let objects = objects {
                self.posts = objects
                self.collectionView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
    }

}

extension ProfileViewController: UINavigationControllerDelegate {

}

extension ProfileViewController: UIImagePickerControllerDelegate {

    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]
    ) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let resizedImage = Util.resizeImage(
            originalImage,
            newSize: CGSize(
                width: profileImageView.frame.width,
                height: profileImageView.frame.height
            )
        )

        let user = PFUser.currentUser()!
        user["imageFile"] = Util.getPFFileFromImage(resizedImage)
        user.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.profileImageView.image = resizedImage
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }

}

extension ProfileViewController: UICollectionViewDataSource {

    func collectionView(
        collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return posts.count
    }

    func collectionView(
        collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            "Post Collection View Cell",
            forIndexPath: indexPath
        ) as! PostCollectionViewCell

        cell.post = posts[indexPath.row]

        return cell
    }

}

extension ProfileViewController: UICollectionViewDelegate {

}

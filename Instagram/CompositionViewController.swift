//
//  CompositionViewController.swift
//  Instagram
//
//  Created by Xiaofei Long on 3/2/16.
//  Copyright © 2016 dreloong. All rights reserved.
//

import UIKit
import MBProgressHUD

class CompositionViewController: UIViewController {

    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var postImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        postImageView.userInteractionEnabled = true
        postImageView.image = UIImage(named: "Square")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Actions

    @IBAction func onCancel(sender: AnyObject) {
        captionField.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSubmit(sender: AnyObject) {
        let progressHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHud.labelText = "Uploading"
        progressHud.labelFont = UIFont.systemFontOfSize(14)

        if postImageView.image != nil && !captionField.text!.isEmpty {
            Post.postUserImage(
                postImageView.image,
                caption: captionField.text,
                completion: { (success: Bool, error: NSError?) -> Void in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                        self.captionField.resignFirstResponder()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            )
        }
    }

    @IBAction func onPostImageViewTap(sender: AnyObject) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = UIImagePickerController.isSourceTypeAvailable(.Camera)
            ? UIImagePickerControllerSourceType.Camera
            : UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
}

extension CompositionViewController: UINavigationControllerDelegate {

}

extension CompositionViewController: UIImagePickerControllerDelegate {

    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]
    ) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let resizedImage = Util.resizeImage(
            originalImage,
            newSize: CGSize(width: postImageView.frame.width, height: postImageView.frame.height)
        )
        postImageView.image = resizedImage
        dismissViewControllerAnimated(true, completion: nil)
    }
}

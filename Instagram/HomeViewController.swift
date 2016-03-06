//
//  HomeViewController.swift
//  Instagram
//
//  Created by Xiaofei Long on 3/2/16.
//  Copyright © 2016 dreloong. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse

let userDidLogoutNotification = "userDidLogoutNotification"
let headerViewIdentifier = "headerViewIdentifier"

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var posts = [PFObject]()
    var refreshControl: UIRefreshControl!

    var targetUser: PFUser?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 365
        tableView.registerClass(
            PostTableViewHeaderFooterView.self,
            forHeaderFooterViewReuseIdentifier: headerViewIdentifier
        )

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let progressHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHud.labelText = "Loading"
        progressHud.labelFont = UIFont.systemFontOfSize(14)
        fetchPostsWithLimit(20)
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "profile" {
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.user = targetUser
        }
    }

    // MARK: - Actions

    @IBAction func onLogoutButtonTouchUp(sender: AnyObject) {
        PFUser.logOut()
        NSNotificationCenter.defaultCenter().postNotificationName(
            userDidLogoutNotification,
            object: nil
        )
    }

    func onRefresh() {
        fetchPostsWithLimit(30)
        refreshControl.endRefreshing()
    }

    // MARK: - Helpers

    func fetchPostsWithLimit(limit: Int) {
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = limit

        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if let objects = objects {
                self.posts = objects
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return posts.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "Post Table View Cell",
            forIndexPath: indexPath
        ) as! PostTableViewCell

        cell.post = posts[indexPath.section]

        return cell
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView =
            tableView.dequeueReusableHeaderFooterViewWithIdentifier(headerViewIdentifier)!
            as! PostTableViewHeaderFooterView
        headerView.delegate = self
        headerView.post = posts[section]
        return headerView
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension HomeViewController: UITableViewDelegate {

}

extension HomeViewController: PostTableViewHeaderFooterViewDelegate {

    func postTableViewHeaderFooterView(
        postTableViewHeaderFooterView: PostTableViewHeaderFooterView,
        didTapProfileImageViewOfPost post: PFObject
    ) {
        targetUser = post.objectForKey("author") as? PFUser
        performSegueWithIdentifier("profile", sender: self)
    }

    func postTableViewHeaderFooterView(
        postTableViewHeaderFooterView: PostTableViewHeaderFooterView,
        didTapUsernameLabelOfPost post: PFObject
    ) {
        targetUser = post.objectForKey("author") as? PFUser
        performSegueWithIdentifier("profile", sender: self)
    }
}

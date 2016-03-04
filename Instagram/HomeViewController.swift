//
//  HomeViewController.swift
//  Instagram
//
//  Created by Xiaofei Long on 3/2/16.
//  Copyright © 2016 dreloong. All rights reserved.
//

import UIKit
import Parse

let userDidLogoutNotification = "userDidLogoutNotification"
let headerViewIdentifier = "headerViewIdentifier"

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var posts = [PFObject]()
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(
            UITableViewHeaderFooterView.self,
            forHeaderFooterViewReuseIdentifier: headerViewIdentifier
        )

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        fetchPostsWithLimit(20)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(headerViewIdentifier)!
            as UITableViewHeaderFooterView
        let author = posts[section].objectForKey("author") as! PFUser
        header.textLabel?.text = author.username
        return header
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

}

extension HomeViewController: UITableViewDelegate {

}

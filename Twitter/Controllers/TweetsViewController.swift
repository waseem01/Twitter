//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/12/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets = [Tweet]()
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var tweetContainerView: TweetContainerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

//        Tweet().getTweets(success: { tweets in
//            self.tweets = tweets
//            self.tableView.reloadData()
//        }) { error in
//            print(error)
//        }
    }

    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        User().logout(success: { (success) in
            print(success)
        }) { (error) in
            print(error)
        }
    }
    
    @IBAction func tweetTapped(_ sender: UIBarButtonItem) {

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

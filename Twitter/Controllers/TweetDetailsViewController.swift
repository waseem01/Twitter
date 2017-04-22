//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/15/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {

    var tweet = Tweet()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tweetButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        navigationController?.navigationBar.topItem?.title = ""
        tweetButton.tintColor = Colors.twitterBlue
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postTweet" {
            let postTweetViewController = segue.destination as! PostTweetViewController
            postTweetViewController.tweet = tweet
        }
//        else {
//            let tweetsViewController = segue.destination as! TweetsViewController
//            tweetsViewController.newTweet = tweet
//        }
    }

    // MARK: - TweetCellDelegate
    func tweetCell(replyToTweetInCell cell: TweetCell) {
        performSegue(withIdentifier: "postTweet", sender: cell)
    }

    func tweetCell(retweetedOrFavoritedInCell cell: TweetCell) {
        let indexPath = tableView.indexPath(for: cell)
        tweet = cell.tweet
        tableView.reloadRows(at: [indexPath!], with: .automatic)
    }

    func userProfileTapped(_ user: User) {
        performSegue(withIdentifier: "showProfile", sender: user)
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        cell.tweet = tweet
        cell.delegate = self
        return cell
    }

}

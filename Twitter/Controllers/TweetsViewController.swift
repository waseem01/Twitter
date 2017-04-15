//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/12/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {

    var tweets = [Tweet]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var twitterLogo: UIImageView!
    @IBOutlet weak var tweetButton: UIBarButtonItem!

//    @IBOutlet weak var tweetContainerView: TweetContainerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        logoutButton.tintColor = Colors.twitterBlue
        tweetButton.tintColor = Colors.twitterBlue
        let image = UIImage(named: "tweet")?.withRenderingMode(.alwaysTemplate)
        twitterLogo.contentMode = .scaleAspectFit
        twitterLogo.tintColor = Colors.twitterBlue
        twitterLogo.image = image

        Tweet().getTweets(success: { tweets in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { error in
            print(error)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTweetDetails" {
            let tweetDetailsViewController = segue.destination as! TweetDetailsViewController
            let cell = sender as! TweetCell
            let indexPath = tableView.indexPath(for: cell)
            tweetDetailsViewController.tweet = tweets[(indexPath?.row)!]
        } else if segue.identifier == "postTweet" {
            let postTweetViewController = segue.destination as! PostTweetViewController
            let cell = sender as! TweetCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]
            postTweetViewController.replyTweetHandle = tweet.handle!
        }
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
        cell.delegate = self
        return cell
    }

    func tweetCell(replyToTweetInCell cell: TweetCell) {
        performSegue(withIdentifier: "postTweet", sender: cell)
    }
}

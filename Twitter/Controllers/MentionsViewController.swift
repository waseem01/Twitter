//
//  MentionsViewController.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/23/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {

    var tweets = [Tweet]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    @IBOutlet weak var twitterLogo: UIImageView!
    @IBOutlet weak var tweetButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        navigationController?.navigationBar.topItem?.title = ""
        hamburgerButton.tintColor = Colors.twitterBlue
        tweetButton.tintColor = Colors.twitterBlue
        let image = UIImage(named: "tweet")?.withRenderingMode(.alwaysTemplate)
        twitterLogo.contentMode = .scaleAspectFit
        twitterLogo.tintColor = Colors.twitterBlue
        twitterLogo.image = image
        fetchMentions()
    }

    private func fetchMentions() {
        Tweet().request(method: .loadMentions   , parameters: nil, success: { tweets in
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
        } else if segue.identifier == "postTweet" && sender is TweetCell {
            let postTweetViewController = segue.destination as! PostTweetViewController
            let cell = sender as! TweetCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]
            postTweetViewController.tweet = tweet
        } else if (segue.identifier == "showProfile") {
            let destinationViewController = segue.destination as! ProfileViewController
            destinationViewController.user = sender as! User
        }
    }

    @IBAction func hamburgerButtonTapped(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HamburgerTapped"), object: nil)
    }

    // MARK: - UITableViewDelegate
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

    func tweetCell(retweetedOrFavoritedInCell cell: TweetCell) {
        let indexPath = tableView.indexPath(for: cell)
        tweets[(indexPath?.row)!] = cell.tweet
        tableView.reloadRows(at: [indexPath!], with: .automatic)
    }

    func userProfileTapped(_ user: User) {
        performSegue(withIdentifier: "showProfile", sender: user)
    }
}

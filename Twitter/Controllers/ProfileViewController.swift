//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/22/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileHeaderImageView: UIImageView!
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    @IBOutlet weak var twitterLogo: UIImageView!
    @IBOutlet weak var tweetButton: UIBarButtonItem!

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!

    var user: User!
    var tweets = [Tweet]()

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }

    private func refresh() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        user = user ?? User.currentUser
        userInfoView.layer.shadowOffset = CGSize(width: 0, height: 1)
        userInfoView.layer.shadowOpacity = 0.25
        userInfoView.layer.shadowRadius = 2
        userInfoView.backgroundColor = .clear
        profileHeaderImageView.setImageWith(user.profileHeaderUrl!)
        profileImageView.setImageWith(user.profileImageUrl!)
        userNameLabel.text = user?.name
        userHandleLabel.text = user?.handle
        navigationItem.title = user.name
        navigationController?.navigationBar.topItem?.title = ""
        hamburgerButton.tintColor = Colors.twitterBlue
        tweetButton.tintColor = Colors.twitterBlue
        let image = UIImage(named: "tweet")?.withRenderingMode(.alwaysTemplate)
        twitterLogo.contentMode = .scaleAspectFit
        twitterLogo.tintColor = Colors.twitterBlue
        twitterLogo.image = image
        followingLabel.text = String(format: "%@ Following", "\(user.followingCount)")
        followersLabel.text = String(format: "%@ Followers", "\(user.followersCount)")
        fetchTimeline()
    }

    private func fetchTimeline() {
        Tweet().request(method: .loadTimeline, parameters: ["screenname": user.handle as AnyObject], success: { tweets in
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
        }
    }

    @IBAction func hamburgerButtonTapped(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HamburgerTapped"), object: nil)
    }

    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        
        UIView.transition(with: userInfoView,
                          duration: 0.75,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.profileHeaderImageView.alpha = self.descriptionLabel.isHidden ? 0.35 : 1
                            self.userNameLabel.isHidden = self.descriptionLabel.isHidden
                            self.userHandleLabel.isHidden = self.descriptionLabel.isHidden
                            self.descriptionLabel.isHidden = self.descriptionLabel.isHidden
                            self.followersLabel.isHidden = self.descriptionLabel.isHidden
                            self.followingLabel.isHidden = self.descriptionLabel.isHidden
                            self.profileImageView.isHidden = self.descriptionLabel.isHidden
                            self.descriptionLabel.isHidden = !self.descriptionLabel.isHidden
        }, completion: nil)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TweetCell
        self.user = cell.tweet.user
        refresh()
    }

    // MARK: - TweetCellDelegate
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

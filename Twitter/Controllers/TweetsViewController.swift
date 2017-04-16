//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/12/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, TweetCellDelegate {

    var tweets = [Tweet]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var twitterLogo: UIImageView!
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    let pullToRefreshControl = UIRefreshControl()
    var isMoreDataLoading = false
    var newTweet : Tweet!

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

        pullToRefreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        pullToRefreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        tableView.insertSubview(pullToRefreshControl, at: 0)
        fetchTweets()

        var insets = tableView.contentInset
        insets.bottom += activityIndicator.frame.size.height
        tableView.contentInset = insets
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTweetDetails" {
            let tweetDetailsViewController = segue.destination as! TweetDetailsViewController
            let cell = sender as! TweetCell
            let indexPath = tableView.indexPath(for: cell)
            tweetDetailsViewController.tweet = tweets[(indexPath?.row)!]
        } else if segue.identifier == "postTweetFromResults" && sender is TweetCell {
            let postTweetViewController = segue.destination as! PostTweetViewController
            let cell = sender as! TweetCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]
            postTweetViewController.tweet = tweet
        }
    }

    // MARK: - Private Methods
    @objc private func pullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchTweets()
    }

    private func fetchTweets() {
        Tweet().request(method: .loadTweets, parameters: nil, success: { tweets in
            self.tweets = tweets
            self.tableView.reloadData()
            self.pullToRefreshControl.endRefreshing()
        }) { error in
            print(error)
            self.pullToRefreshControl.endRefreshing()
        }
    }

    private func loadMoreData() {
        Tweet().request(method: .loadMoreTweets, parameters: nil, success: { tweets in
            self.tweets.append(contentsOf: tweets)
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }) { error in
            print(error)
            self.activityIndicator.stopAnimating()
        }
    }

    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        User().logout(success: { (success) in
            print(success)
        }) { (error) in
            print(error)
        }
    }

    // MARK: - TweetCellDelegate
    func tweetCell(replyToTweetInCell cell: TweetCell) {
        performSegue(withIdentifier: "postTweetFromResults", sender: cell)
    }

    func tweetCell(retweetedOrFavoritedInCell cell: TweetCell) {
        let indexPath = tableView.indexPath(for: cell)
        tweets[(indexPath?.row)!] = cell.tweet
        tableView.reloadRows(at: [indexPath!], with: .automatic)
    }

    @IBAction func unwindToTweetsViewController(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindToTweets" {
            tweets.insert(newTweet, at: 0)
            let firstIndex = IndexPath(row: 0, section: 0)
            tableView.beginUpdates()
            tableView.insertRows(at: [firstIndex], with: .fade)
            tableView.reloadRows(at: [firstIndex], with: .fade)
            tableView.endUpdates()
        } else if segue.identifier == "unwindToResults" {
            let tweetIds = tweets.flatMap({$0.tweet_id})
            let index = tweetIds.index(of: newTweet.tweet_id!)
            tweets[index!] = newTweet
            let indexPath = IndexPath(row: index!, section: 0)
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
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

    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: 60)
                activityIndicator.frame = frame
                activityIndicator.startAnimating()
                loadMoreData()
            }
        }
    }

    // MARK: - Lazy Initializer
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.frame = CGRect(x: 0, y: self.tableView.contentSize.height, width: self.tableView.bounds.size.width, height: 60)
        indicator.hidesWhenStopped = true
        self.tableView.addSubview(indicator)
        return indicator
    }()
}

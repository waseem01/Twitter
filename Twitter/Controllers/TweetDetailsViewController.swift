//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/15/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController, TweetViewDelegate {

    var tweet = Tweet()
    @IBOutlet weak var tweetContainerView: TweetContainerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetContainerView.tweet = tweet
        tweetContainerView.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.presentedViewController == nil {
            self.performSegue(withIdentifier: "unwindToResults", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postTweetFromDetails" {
            let postTweetViewController = segue.destination as! PostTweetViewController
            let tweet = sender as! Tweet
            postTweetViewController.tweet = tweet
        } else {
            let tweetsViewController = segue.destination as! TweetsViewController
            tweetsViewController.newTweet = tweet
        }
    }

    func tweetView(replyToTweetInView tweet: Tweet) {
        performSegue(withIdentifier: "postTweetFromDetails", sender: tweet)
    }

    func tweetView(retweetedOrFavoritedInView tweet: Tweet) {
        self.tweet = tweet
    }

}

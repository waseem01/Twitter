//
//  PostTweetViewController.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/15/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit
import AFNetworking

class PostTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    var newTweet: Tweet!

    var placeholder : UILabel!
    var tweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.delegate = self
        setupPlaceholder()
        tweetButton.layer.cornerRadius = 3
        tweetButton.clipsToBounds = true
        tweetButton.backgroundColor = Colors.twitterBlue
        userImageView.setImageWith((User.currentUser?.profileImageUrl)!)
        userNameLabel.text = User.currentUser?.name
        userHandle.text = String(format: "@%@", (User.currentUser?.screeName)!)
        if let handle = tweet?.handle {
            tweetTextView.text = handle + " "
            updateTweetView(tweetTextView)
        }
        tweetTextView.becomeFirstResponder()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tweetsViewController = segue.destination as! TweetsViewController
        tweetsViewController.newTweet = newTweet
    }

    @IBAction func postTweetTapped(_ sender: UIButton) {

        var parameters = [String : AnyObject]()

        if let replyTweet = tweet {
            parameters["in_reply_to_status_id"] = replyTweet.tweet_id as AnyObject
        }
        parameters["status"] = tweetTextView.text as AnyObject
        Tweet().request(method: .post, parameters: parameters, success: { response in
            self.dismiss(animated: true, completion: nil)
            self.newTweet = response.first!
            self.performSegue(withIdentifier: "unwindToTweets", sender: self)
            print(response)
        }) { error in
            print(error)
        }
    }

    // MARK: - Private Methods
    private func setupPlaceholder() {
        placeholder = UILabel()
        placeholder.text = "What's happening?"
        placeholder.font = UIFont.italicSystemFont(ofSize: (tweetTextView.font?.pointSize)!)
        placeholder.sizeToFit()
        tweetTextView.addSubview(placeholder)
        placeholder.frame.origin = CGPoint(x: 5, y: (tweetTextView.font?.pointSize)! / 2)
        placeholder.textColor = UIColor.lightGray
        placeholder.isHidden = !tweetTextView.text.isEmpty
    }

    func textViewDidChange(_ textView: UITextView) {
        updateTweetView(textView)
    }

    private func updateTweetView(_ textView: UITextView) {
        placeholder.isHidden = !textView.text.isEmpty
        let count = textView.text.characters.count
        let tweetCount = 140-count
        tweetCountLabel.text? = String(format: "%d", tweetCount)

        if count > 140 {
            tweetButton.isEnabled = false
            tweetButton.backgroundColor = .lightGray
            tweetButton.titleLabel?.textColor = .white
        } else if tweetCount >= 0 {
            tweetButton.isEnabled = true
            tweetButton.backgroundColor = Colors.twitterBlue
            tweetButton.titleLabel?.textColor = .white
        }
        if tweetCount < 10 {
            tweetCountLabel.textColor = .red
        }
    }

    @IBAction func closeTweet(_ sender: UIButton) {
        tweetTextView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
}

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
    
    
    var placeholder : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.becomeFirstResponder()
        tweetTextView.delegate = self
        setupPlaceholder()
        tweetButton.layer.cornerRadius = 3
        tweetButton.clipsToBounds = true
        let imageUrl = URL(string: (User.currentUser?.profileImageUrl)!)
        tweetButton.backgroundColor = Colors.twitterBlue
        userImageView.backgroundColor = .red
        userImageView.setImageWith(imageUrl!)
        userNameLabel.text = User.currentUser?.name
        userHandle.text = String(format: "@%@", (User.currentUser?.screeName)!)
    }

    @IBAction func postTweetTapped(_ sender: UIButton) {
    }

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

//
//  TweetCell.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/13/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    var tweet = Tweet() {
        didSet {
            updateCell(withTweet: tweet)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowOpacity = 0.25
        containerView.layer.shadowRadius = 2
        contentView.backgroundColor = .clear //TODO 
    }

    func updateCell(withTweet: Tweet) {
        nameLabel.text = tweet.name
        handleLabel.text = tweet.handle
        timeLabel.text = tweet.time
        tweetLabel.text = tweet.text
        userImageView.setImageWith(tweet.profileImageUrl!)
        userImageView.layer.cornerRadius = 3
        userImageView.clipsToBounds = true
    }
}

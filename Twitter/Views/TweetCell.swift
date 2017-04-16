//
//  TweetCell.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/13/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit
import AFNetworking

protocol TweetCellDelegate: NSObjectProtocol {
    func tweetCell(replyToTweetInCell cell: TweetCell)
    func tweetCell(retweetedOrFavoritedInCell cell: TweetCell)
}

class TweetCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetControlBarView: UIView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var retweetedView: UIView!

    weak var delegate: TweetCellDelegate?

    var tweet: Tweet! {
        didSet {
            updateCell(withTweet: tweet)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowOpacity = 0.25
        containerView.layer.shadowRadius = 2
        contentView.backgroundColor = .clear
    }

    // MARK: - Private Methods
    private func updateCell(withTweet: Tweet) {
        nameLabel.text = tweet.name
        handleLabel.text = tweet.handle
        timeLabel.text = tweet.time
        tweetLabel.text = tweet.text
        userImageView.setImageWith(tweet.profileImageUrl!)
        userImageView.layer.cornerRadius = 3
        userImageView.clipsToBounds = true

        if tweet.retweetCount! > 0 {
            retweetCountLabel.text = String(tweet.retweetCount!)
        }

        if tweet.favoriteCount! > 0 {
            favoriteCountLabel.text = String(tweet.favoriteCount!)
        }

        if tweet.retweeterScreenName != nil {
            retweetedView.isHidden = false
            retweetedLabel.text = tweet.retweeterScreenName
        } else {
            retweetedView.isHidden = true
        }
        styleButtons()
    }

    private func styleButtons() {
        [ replyButton, retweetButton, favoriteButton].forEach { button -> () in
            self.updateButtonState(button!)
        }
    }

    @IBAction func replyTapped(_ sender: UIButton) {
        delegate?.tweetCell(replyToTweetInCell: self)
    }

    @IBAction func retweetOrFavoriteTapped(_ sender: UIButton) {
        var method = TweetAction.post
        let tweet_id = tweet.tweet_id
        if sender.tag == 2 {
            method = (tweet.retweeted ? .unretweet : .retweet)
        } else if sender.tag == 3 {
            method = (tweet.favorited ? .unfavorite : .favorite)
        }
        Tweet().request(method: method,
                        parameters: ["tweet_id" : tweet_id as AnyObject],
                        success: { response in
                            self.tweet = response.first!
                            self.delegate?.tweetCell(retweetedOrFavoritedInCell: self)
        }) { error in
            print(error)
        }
    }

    private func updateButtonState(_ button: UIButton) {

        var orginalImage = UIImage()
        var tintedImage = UIImage()
        var color = UIColor()

        switch button.tag {
        case 1:
            orginalImage = UIImage(named: "reply-icon")!;
            tintedImage = orginalImage.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            color = .gray
        case 2:
            orginalImage = UIImage(named: "retweet-icon")!;
            tintedImage = orginalImage.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            color = tweet.retweeted ? Colors.twitterGreen : .gray
        case 3:
            orginalImage = UIImage(named: "star-icon")!;
            tintedImage = orginalImage.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            color = tweet.favorited ? .red : .gray
        default: break
        }
        button.setImage(tintedImage, for: .normal)
        button.tintColor = color
    }
}

//
//  TweetCell.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/13/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit
import AFNetworking

protocol TweetCellDelegate {
    func tweetCell(replyToTweetInCell cell: TweetCell)
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

    var delegate: TweetCellDelegate?

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
        contentView.backgroundColor = .clear
        styleButtons()
    }

    func updateCell(withTweet: Tweet) {
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
    }

    private func styleButtons() {

        [(String, UIButton!)](
            [
                ("reply-icon", replyButton),
                ("retweet-icon", retweetButton),
                ("star-icon", favoriteButton)
            ]
            ).forEach { (imageName, button) -> () in
                let origImage = UIImage(named: imageName);
                let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                button.setImage(tintedImage, for: .normal)
                button.tintColor = .lightGray
        }
    }

    @IBAction func replyTapped(_ sender: UIButton) {
        delegate?.tweetCell(replyToTweetInCell: self)
    }

    @IBAction func retweetTapped(_ sender: UIButton) {
    }

    @IBAction func favoriteTapped(_ sender: UIButton) {
    }
    


    //MARK: Properties
//    private lazy var tweetControlBar: TweetControlBar = {
//        let view = TweetControlBar(frame: CGRect(x: 0, y: 0, width: self.tweetControlView.frame.size.width, height: 20))
////        view.translatesAutoresizingMaskIntoConstraints = false
////        view.center = self.tweetControlView.center
//        return view
//    }()
}

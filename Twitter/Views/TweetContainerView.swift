//
//  TweetContainerView.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/14/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit
import AFNetworking

protocol TweetViewDelegate: NSObjectProtocol {
    func tweetView(replyToTweetInView tweet: Tweet)
    func tweetView(retweetedOrFavoritedInView tweet: Tweet)
}

class TweetContainerView: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!

    weak var delegate: TweetViewDelegate?

    var tweet = Tweet() {
        didSet {
            updateContent(withTweet: tweet)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    func xibSetup() {
        containerView = loadViewFromNib()
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(containerView)
    }

    func loadViewFromNib() -> UIView {

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TweetContainerView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView

        return view
    }

    func updateContent(withTweet: Tweet) {
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
        styleButtons()
    }

    private func styleButtons() {
        [ replyButton, retweetButton, favoriteButton].forEach { button -> () in
            self.updateButtonState(button!)
        }
    }

    private func updateButtonState(_ button: UIButton) {

        var orginalImage = UIImage()
        var tintedImage = UIImage()
        var color = UIColor.white

        switch button.tag {
        case 10:
            orginalImage = UIImage(named: "reply-icon")!;
            tintedImage = orginalImage.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            color = .gray
        case 11:
            orginalImage = UIImage(named: "retweet-icon")!;
            tintedImage = orginalImage.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            color = tweet.retweeted ? Colors.twitterGreen : .gray
        case 12:
            orginalImage = UIImage(named: "star-icon")!;
            tintedImage = orginalImage.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            color = tweet.favorited ? .red : .gray
        default: break
        }
        button.setImage(tintedImage, for: .normal)
        button.tintColor = color
    }
    

    @IBAction func replyTapped(_ sender: UIButton) {
        delegate?.tweetView(replyToTweetInView: tweet)
    }

    @IBAction func retweetOrFavoriteTapped(_ sender: UIButton) {
        var method = TweetAction.post
        let tweet_id = tweet.tweet_id
        if sender.tag == 11 {
            method = (tweet.retweeted ? .unretweet : .retweet)
        } else if sender.tag == 12 {
            method = (tweet.favorited ? .unfavorite : .favorite)
        }
        Tweet().request(method: method,
                        parameters: ["tweet_id" : tweet_id as AnyObject],
                        success: { response in
                            self.tweet = response.first!
                            self.delegate?.tweetView(retweetedOrFavoritedInView: response.first!)
        }) { error in
            print(error)
        }
    }
    
}

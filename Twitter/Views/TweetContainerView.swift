//
//  TweetContainerView.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/14/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit

class TweetContainerView: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

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
    }
}

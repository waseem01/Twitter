//
//  TweetControlBar.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/14/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit

class TweetControlBar: UIView {

    @IBOutlet var tweetControlBar: UIView!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!

    var retweetCount = Int() {
        didSet {
            retweetCountLabel.isHidden = false
            retweetCountLabel.text = String(retweetCount)
        }
    }

    var favoriteCount = Int() {
        didSet {
            favoriteCountLabel.isHidden = false
            favoriteCountLabel.text = String(favoriteCount)
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
        tweetControlBar = loadViewFromNib()
        tweetControlBar.frame = bounds
        tweetControlBar.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(tweetControlBar)
        styleButtons()
    }

    func loadViewFromNib() -> UIView {

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TweetControlBar", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
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
    }

    @IBAction func retweetTapped(_ sender: UIButton) {
    }

    @IBAction func favoriteTapped(_ sender: UIButton) {
    }

}

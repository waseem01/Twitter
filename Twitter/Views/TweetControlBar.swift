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

        styleButton(button: replyButton)
        styleButton(button: retweetButton)
        styleButton(button: favoriteButton)
    }

    func loadViewFromNib() -> UIView {

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TweetControlBar", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

    private func styleButton(button: UIButton) {
        var image = UIImage()

        switch button.tag {
        case 1:
            image = (UIImage(named: "reply-icon")?.withRenderingMode(.alwaysTemplate))!
        case 2:
            image = (UIImage(named: "retweet-icon")?.withRenderingMode(.alwaysTemplate))!
        case 3:
            image = (UIImage(named: "star-icon")?.withRenderingMode(.alwaysTemplate))!
        default : break
        }

        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = .gray
        button.imageView?.image = image
    }

    @IBAction func replyTapped(_ sender: UIButton) {
    }

    @IBAction func retweetTapped(_ sender: UIButton) {
    }

    @IBAction func favoriteTapped(_ sender: UIButton) {
    }

}

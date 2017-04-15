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
    }

    func loadViewFromNib() -> UIView {

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TweetControlBar", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

    @IBAction func replyTapped(_ sender: UIButton) {
    }

    @IBAction func retweetTapped(_ sender: UIButton) {
    }

    @IBAction func favoriteTapped(_ sender: UIButton) {
    }

}

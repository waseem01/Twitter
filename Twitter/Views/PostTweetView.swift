//
//  PostTweetView.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/15/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit

class PostTweetView: UIView {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet var tweetView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    func xibSetup() {
        tweetView = loadViewFromNib()
        tweetView.frame = bounds
        tweetView.backgroundColor = .red
        tweetView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(tweetView)
    }

    func loadViewFromNib() -> UIView {

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PostTweetView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView

        return view
    }

    @IBAction func postTapped(_ sender: UIButton) {
    }
}

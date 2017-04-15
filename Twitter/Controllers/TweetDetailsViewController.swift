//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/15/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {

    var tweet = Tweet()
    @IBOutlet weak var tweetContainerView: TweetContainerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetContainerView.tweet = tweet
    }
}

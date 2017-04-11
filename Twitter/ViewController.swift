//
//  ViewController.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/11/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var twitterClient = TwitterClient()

    override func viewDidLoad() {
        super.viewDidLoad()

        TwitterClient.sharedInstance.authorizeIfRequired()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/12/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets = [Tweet]()
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var tweetContainerView: TweetContainerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        Tweet().getTweets(success: { tweets in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { error in
            print(error)
        }
    }

    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        User().logout(success: { (success) in
            print(success)
        }) { (error) in
            print(error)
        }
    }
    
    @IBAction func tweetTapped(_ sender: UIBarButtonItem) {
        let animationView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width-30, height: 300))
        animationView.center = view.center
        animationView.backgroundColor = .red
        animationView.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.view!.addSubview(animationView)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {() -> Void in
            animationView.transform = .identity
        }, completion: { _ in })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        tweetContainerView.isHidden = !tweetContainerView.isHidden
//        tweetContainerView.tweet = tweets[indexPath.row]
//        tweetContainerView.transform = CGAffineTransform(scaleX: 0, y: 0)
//        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {() -> Void in
//            self.tweetContainerView.transform = .identity
//        }, completion: { _ in })
    }
}

//
//  Tweet.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/12/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit
import OAuthSwift

class Tweet: NSObject {

    var name: String?
    var handle: String?
    var time: String?
    var text: String?
    var profileImageUrl: URL?
    var createdAtString: String?
    var createdAt: Date?
    var retweeted: Bool = false
    var favorited: Bool = false
    var retweetCount: Int?
    var favoriteCount: Int?
    var retweeterScreenName: String?
    var userScreenName: String?

    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweeted = dictionary["retweeted"] as? Int != 0
        favorited = dictionary["favorited"] as? Int != 0
        retweetCount = dictionary["retweet_count"] as? Int
        favoriteCount = dictionary["favorite_count"] as? Int
        userScreenName = dictionary.value(forKeyPath: "user.screen_name") as? String
        
        if dictionary["user"] != nil {
            let userDictionary = dictionary["user"]! as! NSDictionary
            let url = userDictionary["profile_image_url_https"]!
            profileImageUrl = URL(string: (url as? String)!)

            name = userDictionary["name"] as? String
            handle = String(format: "@%@", (userDictionary["screen_name"] as? String)!)
        }

        createdAtString = dictionary["created_at"] as? String

        if createdAtString != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createdAt = formatter.date(from: createdAtString!)
            if Int(Date().timeIntervalSince(createdAt!)/3600) > 0 {
                time = String(format: "%dh", Int(Date().timeIntervalSince(createdAt!)/3600))
            } else if Int(Date().timeIntervalSince(createdAt!)/60) > 0 {
                time = String(format: "%dm", Int(Date().timeIntervalSince(createdAt!)/60))
            } else {
                formatter.dateFormat = "MMM d"
                time = String(format: "%@", formatter.string(from: createdAt!))
            }
        }

//        if let retweetedStatus = dictionary["retweeted_status"] as? NSDictionary {
//            var retweetedTweet = TweetState.Entity(dictionary: retweetedStatus)
//            let retweeterScreenName = userScreenName

//            retweetedTweet.retweeted = retweetedTweet.retweeted || retweeted
//            retweetedTweet.favorited = retweetedTweet.favorited || favorited

//            self = retweetedTweet
//            self.retweeterScreenName = retweeterScreenName
//        }
    }

    convenience override init() {
        self.init(dictionary: [:])
    }

    class func tweetsArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()

        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }

    func getTweets(success: @escaping ([Tweet]) -> Void, failure: @escaping (Error) -> Void) {
        let user_id = User.currentUser?.user_id  as AnyObject
        TwitterClient.sharedInstance.get(url: "/1.1/statuses/home_timeline.json", parameters: ["user_id": user_id], success: { jsonDict in
            let tweets = Tweet.tweetsArray(array: jsonDict as! [NSDictionary])
            success(tweets)
        }, failure: { error in
            failure(error)
        })
    }

    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: Date()).hour ?? 0
    }
}

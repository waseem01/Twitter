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

    init(dictionary: NSDictionary) {
        time = "7h"
        text = dictionary["text"] as? String
        
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
            formatter.date
            createdAt = formatter.date(from: createdAtString!)
        }
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
}

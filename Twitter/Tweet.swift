//
//  Tweet.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/12/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit
import OAuthSwift

enum TweetAction {
    case loadTweets
    case loadMoreTweets
    case post
    case retweet
    case unretweet
    case favorite
    case unfavorite
}

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
    var count = 0
    var tweet_id: String?

    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweeted = (dictionary["retweeted"] as? Bool) ?? false
        favorited = (dictionary["favorited"] as? Bool) ?? false
        retweetCount = dictionary["retweet_count"] as? Int
        
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

        if let retweetedStatus = dictionary["retweeted_status"] as? [String: AnyObject], !retweetedStatus.isEmpty {
            tweet_id = retweetedStatus["id_str"] as? String
            favoriteCount = dictionary.value(forKeyPath: "retweeted_status.favorite_count") as? Int
            retweeterScreenName = userScreenName
        } else {
            tweet_id = dictionary["id_str"] as? String
            favoriteCount = dictionary["favorite_count"]as? Int
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

    func request(method: TweetAction, parameters: [String: AnyObject]?, success: @escaping ([Tweet]) -> Void, failure: @escaping (Error) -> Void) {

        var params = [String : AnyObject]()
        var requestMethod : OAuthSwiftHTTPRequest.Method?

        if let paramsRecieved = parameters {
            for (key, value) in paramsRecieved {
                params.updateValue(value, forKey: key)
            }
        }

        switch method {

        case .loadTweets:
            requestMethod = .GET
            params["url"] = "/1.1/statuses/home_timeline.json" as AnyObject
        case .loadMoreTweets:
            count += 20
            requestMethod = .GET
            params["url"] = "/1.1/statuses/home_timeline.json" as AnyObject
            params["count"] = count  as AnyObject
        case .post:
            requestMethod = .POST
            params["url"] = "/1.1/statuses/update.json" as AnyObject
        case .retweet:
            let id = parameters?["tweet_id"] as! String
            requestMethod = .POST
            params["url"] = "/1.1/statuses/retweet/\(id).json" as AnyObject
        case .unretweet:
            let id = parameters?["tweet_id"] as! String
            requestMethod = .POST
            params["url"] = "/1.1/statuses/unretweet/\(id).json" as AnyObject
        case .favorite:
            requestMethod = .POST
            let id = parameters?["tweet_id"] as! String
            params["url"] = "/1.1/favorites/create.json?id=\(id)" as AnyObject
        case .unfavorite:
            requestMethod = .POST
            let id = parameters?["tweet_id"] as! String
            params["url"] = "/1.1/favorites/destroy.json?id=\(id)" as AnyObject
        }

        TwitterClient.sharedInstance.request(method: requestMethod!, parameters: params, success: { jsonDict in
            switch method {
            case .loadTweets, .loadMoreTweets:
                let tweets = Tweet.tweetsArray(array: jsonDict as! [NSDictionary])
                success(tweets)
            case .post, .retweet, .unretweet, .favorite, .unfavorite:
                let tweets = Tweet.tweetsArray(array: [jsonDict as! NSDictionary])
                success(tweets)
            }
        }, failure: { error in
            failure(error)
        })
    }
}

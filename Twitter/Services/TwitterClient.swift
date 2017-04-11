//
//  TwitterClient.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/11/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import Unbox
import OAuthSwift

class TwitterClient {

    private static let consumerKey = "hWooo1j45eBfi912rkQFkIfQc"
    private static let consumerSecret = "9sdh02vdLcyAC2O8k0h8JbGruezX5MfaS6MDratXgKqkuiABQd"
    private let apiBaseUrl = "https://api.twitter.com"
    static let sharedInstance = TwitterClient()
    var oauthToken: String!
    var oauthTokenSecret: String!
    var userId: String!
    var userScreenName: String!

    let oauthswift  = OAuth1Swift(
        consumerKey:      consumerKey,
        consumerSecret:   consumerSecret,
        requestTokenUrl:  "https://api.twitter.com/oauth/request_token",
        authorizeUrl:     "https://api.twitter.com/oauth/authorize",
        accessTokenUrl:   "https://api.twitter.com/oauth/access_token"
    )

    func authorizeIfRequired() {

        oauthswift.authorize(withCallbackURL: URL(string: "tweetyclone://oauth")!, success: { (credential, response, parameters) in
            self.oauthToken = credential.oauthToken
            self.oauthTokenSecret = credential.oauthTokenSecret
            self.userId = parameters["user_id"] as! String
            self.userScreenName = parameters["screen_name"] as! String

            print(credential)
            print(response!)
            print(parameters)

        }, failure: { (error) in
            print(error)
        })
    }
}

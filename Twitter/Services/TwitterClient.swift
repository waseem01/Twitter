//
//  TwitterClient.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/11/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import OAuthSwift

class TwitterClient {

    static let consumerKey = "hWooo1j45eBfi912rkQFkIfQc"
    static let consumerSecret = "9sdh02vdLcyAC2O8k0h8JbGruezX5MfaS6MDratXgKqkuiABQd"
    private let apiBaseUrl = "https://api.twitter.com"
    static let sharedInstance = TwitterClient()

    let oauthswift  = OAuth1Swift(
        consumerKey:      consumerKey,
        consumerSecret:   consumerSecret,
        requestTokenUrl:  "https://api.twitter.com/oauth/request_token",
        authorizeUrl:     "https://api.twitter.com/oauth/authorize",
        accessTokenUrl:   "https://api.twitter.com/oauth/access_token"
    )

    func request(method: OAuthSwiftHTTPRequest.Method, parameters: [String : AnyObject], success: @escaping (AnyObject) -> Void, failure: @escaping (Error) -> Void) {

        let url = parameters["url"] as! String

        switch method {
        case .GET:
            self.authorizeIfRequired(success: { twitterClient in
                var params = (parameters.count) > 1 ? parameters : [:]
                let oauthUrl = self.apiBaseUrl + url
                params.removeValue(forKey: "url")
                let _ = self.oauthswift.client.get(oauthUrl, parameters: params,
                                                   success: { response in
                                                    let jsonDict = try? response.jsonObject()
                                                    success(jsonDict as AnyObject)
                },
                                                   failure: { error in
                                                    failure(error)
                })
            }, failure: { error in
                failure(error)
            })
        case .POST:
            var params = (parameters.count) > 0 ? parameters : [:]
            let oauthUrl = self.apiBaseUrl + url
            params.removeValue(forKey: "url")
            let _ = self.oauthswift.client.post(oauthUrl, parameters: params,
                                                success: { response in
                                                    let jsonDict = try? response.jsonObject()
                                                    success(jsonDict as AnyObject)
            },
                                                failure: { error in
                                                    failure(error)
            })
        default: break
        }
    }

    //MARK: - Private Methods
    private func authorizeIfRequired(success: @escaping (TwitterClient) -> Void, failure: @escaping (Error) -> Void) {

        let userDefaults = UserDefaults.standard
        var oauthToken = userDefaults.string(forKey: "twitter:oauthToken") ?? ""
        var oauthTokenSecret = userDefaults.string(forKey: "twitter:oauthTokenSecret") ?? ""

        if User.currentUser != nil {
            TwitterClient.sharedInstance.oauthswift.client = OAuthSwiftClient(consumerKey: TwitterClient.consumerKey,
                                                                              consumerSecret: TwitterClient.consumerSecret,
                                                                              oauthToken: oauthToken,
                                                                              oauthTokenSecret: oauthTokenSecret,
                                                                              version: .oauth1)
            return success(self)
        }

        oauthswift.authorize(withCallbackURL: URL(string: "tweetyclone://oauth")!,
                             success: { credential, response, parameters in

                                oauthToken = credential.oauthToken
                                oauthTokenSecret = credential.oauthTokenSecret

                                userDefaults.setValue(oauthToken, forKey: "twitter:oauthToken")
                                userDefaults.setValue(oauthTokenSecret, forKey: "twitter:oauthTokenSecret")
                                userDefaults.synchronize()

                                success(self)
                                
        }, failure: { (error) in
            
            failure(error)
        })
    }
}


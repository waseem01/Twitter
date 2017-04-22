//
//  User.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/12/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit
import OAuthSwift

enum UserAction {
    case login
    case logout
}

var _currentUser: User?

class User: NSObject {

    var name: String?
    var user_id: Int?
    var handle: String?
    var profileImageUrl: URL?
    var profileHeaderUrl: URL?
    var tagLine: String?
    var dictionary: NSDictionary?
    var parameters = [String : AnyObject]()
    var followersCount: Int = 0
    var followingCount: Int = 0

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        user_id = dictionary["id"] as? Int
        if let name = dictionary["screen_name"] as? String {
            handle = String(format: "@%@", name)
        }
        if let url = dictionary["profile_image_url_https"] {
            profileImageUrl = URL(string: (url as? String)!)
        }
        if let url = dictionary["profile_background_image_url_https"] {
            profileHeaderUrl = URL(string: (url as? String)!)
        }
        followersCount = (dictionary["followers_count"] as? Int) ?? 0
        followingCount = (dictionary["following"] as? Int) ?? 0
        tagLine = dictionary["description"] as? String
    }

    convenience override init() {
        self.init(dictionary: [:])
    }

    class var currentUser: User? {

        get {
            if _currentUser == nil {
                let userData = UserDefaults.standard.object(forKey: "twitter:currentUser") as? Data
                if userData != nil {
                    let dictionary = try? JSONSerialization.jsonObject(with: userData!, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary!)
                }
            }
            return _currentUser

        } set(user) {
            _currentUser = user

            if _currentUser != nil {
                let userData = try? JSONSerialization.data(withJSONObject: user!.dictionary!, options: [])
                UserDefaults.standard.setValue(userData, forKey: "twitter:currentUser")
            } else {
                UserDefaults.standard.setValue(nil, forKey: "twitter:currentUser")
            }
            UserDefaults.standard.synchronize()
        }
    }

    func getTwitterUser(success: @escaping (User) -> Void, failure: @escaping (Error) -> Void) {
        parameters["url"] = "/1.1/account/verify_credentials.json" as AnyObject
        TwitterClient.sharedInstance.request(method: .GET, parameters: parameters, success: { jsonDict in
            let user = User(dictionary: jsonDict as! NSDictionary)
            User.currentUser = user
            success(user)
        }, failure: { error in
            failure(error)
        })
    }

    func logout(success: @escaping (AnyObject) -> Void, failure: @escaping (Error) -> Void) {
        parameters["url"] = "/oauth2/invalidate_token" as AnyObject
        parameters["access_token"] = UserDefaults.standard.string(forKey: "twitter:oauthToken") as AnyObject

        TwitterClient.sharedInstance.request(method: .POST, parameters: parameters, success: { jsonDict in
            success(jsonDict)
        }, failure: { error in
            failure(error)
        })
        _currentUser = nil
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = storyboard.instantiateInitialViewController()!
    }
}

//
//  User.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/12/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit
import OAuthSwift

var _currentUser: User?

class User: NSObject {

    var name: String?
    var user_id: Int?
    var screeName: String?
    var profileImageUrl: String?
    var tagLine: String?
    var dictionary: NSDictionary?

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        user_id = dictionary["id"] as? Int
        screeName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
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
        TwitterClient.sharedInstance.get(url: "/1.1/account/verify_credentials.json", parameters: [:], success: { jsonDict in
            let user = User(dictionary: jsonDict as! NSDictionary)
            User.currentUser = user
            success(user)
        }, failure: { error in
            failure(error)
        })
    }

    func logout(success: @escaping (AnyObject) -> Void, failure: @escaping (Error) -> Void) {
        let access_token = UserDefaults.standard.string(forKey: "twitter:oauthToken") as AnyObject
        TwitterClient.sharedInstance.post(url: "/oauth2/invalidate_token", parameters: ["access_token" : access_token], success: { jsonDict in
            success(jsonDict)
            _currentUser = nil
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.synchronize()

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window!.rootViewController = storyboard.instantiateInitialViewController()!
        }, failure: { error in
            failure(error)
        })
    }
}

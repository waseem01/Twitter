//
//  LoginViewController.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/12/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!

    var user: User?

    override func viewWillLayoutSubviews() {

        UIView.animate(withDuration: 2.0) {
            self.scrollView.setContentOffset(CGPoint(x: 0,y: self.scrollView.contentInset.top + 20), animated: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height + 20)
        loginButton.layer.cornerRadius = 3
        loginButton.clipsToBounds = true
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        sender.isHidden = true
        User().getTwitterUser(success: { user in
            self.user = user
            let initialController = self.storyboard?.instantiateViewController(withIdentifier: "HamburgerMenuView")
//            let navigationController = UINavigationController.init(rootViewController: initialController!)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window!.rootViewController = initialController
        }) { error in
            print(error)
        }
    }
}

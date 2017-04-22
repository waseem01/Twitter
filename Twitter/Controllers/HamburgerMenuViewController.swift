//
//  HamburgerMenuViewController.swift
//  Twitter
//
//  Created by Waseem Mohd on 4/21/17.
//  Copyright © 2017 Mohammed. All rights reserved.
//

import UIKit

class HamburgerMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var headerView: UIView!

    @IBOutlet weak var containerViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuLeftConstraint: NSLayoutConstraint!

    var menuOptions = ["Profile", "Timeline",
                       "Mentions", "Logout"]
    var controllerOptions = ["ProfileViewNavigationController", "TweetsViewNavigationController",
                             "MentionsViewNavigationController", "LoginViewController"]

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuView()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hideShowMenu),
            name: NSNotification.Name(rawValue: "HamburgerTapped"),
            object: nil)
    }

    func setupMenuView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.layer.shadowColor = UIColor.darkGray.cgColor
        tableView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        tableView.layer.shadowOpacity = 0.0
        tableView.layer.shadowRadius = 2
        tableView.clipsToBounds = false;
        tableView.layer.masksToBounds = false;
        headerView.backgroundColor = Colors.twitterBlue
        let user = User.currentUser
        profileImageView.setImageWith((user?.profileImageUrl)!)
        userNameLabel.text = user?.name
        handleLabel.text = user?.handle
        menuLeftConstraint.constant = 0 - tableView.frame.size.width
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MenuCell")!

        let menuImageView : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        menuImageView.image = UIImage(named: menuOptions[indexPath.row])

        let menuTitleLabel : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        menuTitleLabel.text = menuOptions[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if menuOptions[indexPath.row] == "Logout" {
            User().logout(success: { (success) in
                print(success)
            }) { (error) in
                print(error)
            }
            return
        }

        let existingView = containerView.viewWithTag(indexPath.row+1)
        if let view = existingView {
            containerView.bringSubview(toFront: view)
        } else {
            let controllerIdentifier = controllerOptions[indexPath.row]
            let controller = storyboard!.instantiateViewController(withIdentifier: controllerIdentifier)
            addChildViewController(controller)
            controller.view.tag = indexPath.row + 1
            containerView.addSubview(controller.view)
            controller.didMove(toParentViewController: self)
        }
        hideShowMenu()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }

    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        if sender.state == .ended {
            hideShowMenu()
        }
    }

    func hideShowMenu() {
        if self.menuLeftConstraint.constant == 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.containerViewLeftConstraint.constant = 0
                self.tableView.layer.shadowOpacity = 0.0
                self.menuLeftConstraint.constant = 0 - self.tableView.frame.size.width
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.menuLeftConstraint.constant = 0
                self.tableView.layer.shadowOpacity = 1.0
                self.containerViewLeftConstraint.constant = self.tableView.frame.size.width
                self.view.layoutIfNeeded()
            })
        }
    }
}

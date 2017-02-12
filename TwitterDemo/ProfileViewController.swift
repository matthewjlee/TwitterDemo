//
//  ProfileViewController.swift
//  TwitterDemo
//
//  Created by Richard Du on 2/9/17.
//  Copyright © 2017 Richard Du. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var userID: Int?
    override func viewWillAppear(_ animated: Bool) {
        TwitterClient.sharedInstance?.userLookup(success: { (users: [User]) in
            let user = users[0]
            usernameLabel = user.name
            screennameLabel = "@\(user.screenname!)"
            if let profileImageURL = user.profileUrl {
                profileImageView.setImageWith(profileImageURL)
            }
            
        }, failure: { (error:Error) in
            print(error.localizedDescription)
        }, userID: userID!)
        
        TwitterClient.sharedInstance?.userTimeline(success: { (tweets:[Tweet]) in
            print(tweets)
        }, failure: { (errorError) in
            print(error.localizedDescription)
        }, userID: userID!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

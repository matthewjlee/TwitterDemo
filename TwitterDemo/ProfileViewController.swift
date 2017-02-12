//
//  ProfileViewController.swift
//  TwitterDemo
//
//  Created by Richard Du on 2/9/17.
//  Copyright © 2017 Richard Du. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var isProfile: Bool = true
    @IBOutlet weak var composeTweetButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    var tweets: [Tweet]!
    var userID: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        TwitterClient.sharedInstance?.userLookup(success: { (users: [User]) in
            let user = users[0]
            
            self.usernameLabel.text = user.name
            self.screennameLabel.text = "@\(user.screenname!)"
            if let profileImageURL = user.profileUrl {
                self.profileImageView.setImageWith(profileImageURL)
            }
            self.tweetCountLabel.text = "\(user.tweetCount)"
            self.followingCountLabel.text = "\(user.followingCount)"
            self.followersCountLabel.text = "\(user.followersCount)"
            
            if self.isProfile {
                self.composeTweetButton.isHidden = false
            } else {
                self.composeTweetButton.isHidden = true
            }
            
        }, failure: { (error:Error) in
            print(error.localizedDescription)
        }, userID: userID!)
        
        TwitterClient.sharedInstance?.userTimeline(success: { (tweets:[Tweet]) in
            print(tweets)
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        }, userID: userID!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterCell", for: indexPath) as! TwitterCell
        
        
        let tweet = tweets[indexPath.row]
        cell.tweetTextLabel.text = tweet.text
        cell.retweetsLabel.text = "\(tweet.retweetCount)"
        cell.favoritesLabel.text = "\(tweet.favoritesCount)"
        cell.usernameLabel.text = tweet.username
        cell.screenNameLabel.text = "@\(tweet.screenName!)"
        
        
        let date = tweet.timestamp
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM YY"
        
        let elapsed = Int(Date().timeIntervalSince(date!))
        
        var timestamp: String?
        if elapsed/60 == 0 {
            timestamp = "\(elapsed)s"
        } else if elapsed/3600 == 0 {
            timestamp = "\(elapsed/60)m"
        } else if elapsed/86400 == 0 {
            timestamp = "\(elapsed/3600)h"
        } else if elapsed/604800 == 0 {
            timestamp = "\(elapsed/86400)d"
        } else {
            timestamp = formatter.string(from: date!)
        }
        
        cell.timestampLabel.text = timestamp
        if let profileImageURL = tweet.profileImageURL as URL? {
            cell.profileImageView.setImageWith(profileImageURL)
        }
        
        if let tweetImageURL = tweet.tweetImageURL as URL? {
            cell.tweetImageView.setImageWith(tweetImageURL)
        }
        
        DispatchQueue.main.async {
            print("ABCDCEFG\trow:\(indexPath.row)")
            if tweet.retweetStatus == true {
                cell.retweetsLabel.textColor = UIColor.green
                cell.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: UIControlState.normal)
            } else {
                cell.retweetsLabel.textColor = UIColor.black
                cell.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: UIControlState.normal)
            }
            
            if tweet.favoriteStatus == true {
                cell.favoritesLabel.textColor = UIColor.red
                cell.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: UIControlState.normal)
            } else {
                cell.favoritesLabel.textColor = UIColor.black
                cell.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: UIControlState.normal)
            }
        }
        
        
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let sender = sender as? UITableViewCell {
            let cell = sender
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[indexPath!.row]
            
            let detailViewController = segue.destination as! TweetsDetailsViewController
            detailViewController.tweet = tweet
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

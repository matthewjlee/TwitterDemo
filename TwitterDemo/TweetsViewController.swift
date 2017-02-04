//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Richard Du on 2/3/17.
//  Copyright © 2017 Richard Du. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets: [Tweet]!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
            TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
                self.tweets = tweets
                self.tableView.reloadData()
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        
            
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.logout()
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
        cell.retweetImageView.image = #imageLiteral(resourceName: "retweet-icon")
        cell.favoritesImageView.image = #imageLiteral(resourceName: "favor-icon")
        cell.usernameLabel.text = tweet.username
        cell.screenNameLabel.text = "@\(tweet.screenName!)"
        cell.timestampLabel.text = tweet.timestamp
        if let profileImageURL = tweet.profileImageURL as URL? {
            cell.profileImageView.setImageWith(profileImageURL)
        }
        
        if let tweetImageURL = tweet.tweetImageURL as URL? {
            cell.tweetImageView.setImageWith(tweetImageURL)
        }
        
        
        return cell
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

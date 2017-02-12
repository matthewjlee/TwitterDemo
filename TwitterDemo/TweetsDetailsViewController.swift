//
//  TweetsDetailsViewController.swift
//  TwitterDemo
//
//  Created by Richard Du on 2/9/17.
//  Copyright © 2017 Richard Du. All rights reserved.
//

import UIKit

class TweetsDetailsViewController: UIViewController {

    var tweet: Tweet!
    var tweetID: Int = 0
    
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tweetID = tweet.tweetID
        usernameLabel.text = tweet.username
        screennameLabel.text = tweet.screenName
        retweetCountLabel.text = "\(tweet.retweetCount)"
        likesCountLabel.text = "\(tweet.favoritesCount)"
        tweetLabel.text = tweet.text
        if let profileImageURL = tweet.profileImageURL as URL? {
            profileImageView.setImageWith(profileImageURL)
        }
        
        if let tweetImageURL = tweet.tweetImageURL as URL? {
            tweetImageView.setImageWith(tweetImageURL)
        }
        
        let date = tweet.timestamp
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a • dd MMM yy"
        
        timestampLabel.text = formatter.string(from: date!)
        
        
        /*
        cell.tweetTextLabel.text = tweet.text
        cell.retweetsLabel.text = "\(tweet.retweetCount)"
        cell.favoritesLabel.text = "\(tweet.favoritesCount)"
        cell.usernameLabel.text = tweet.username
        cell.screenNameLabel.text = "@\(tweet.screenName!)"
        cell.timestampLabel.text = tweet.timestamp
        if let profileImageURL = tweet.profileImageURL as URL? {
            cell.profileImageView.setImageWith(profileImageURL)
        }
        
        if let tweetImageURL = tweet.tweetImageURL as URL? {
            cell.tweetImageView.setImageWith(tweetImageURL)
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweet(_ sender: AnyObject) {

        self.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: UIControlState.normal)
        
        
        TwitterClient.sharedInstance?.retweet(success: { (tweet: Tweet) in
            print(tweet.favoritesCount)
            self.retweetCountLabel.text = "\(tweet.retweetCount)"
            
            
        }, failure: { (error: Error) in
            
            print(error.localizedDescription)
        }, tweetID: tweetID)
    }
    
    @IBAction func onFavorite(_ sender: AnyObject) {
        
        self.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: UIControlState.normal)
        
        
        
        TwitterClient.sharedInstance?.favorite(success: { (tweet: Tweet) in
            print("favorite")
            print(tweet.favoritesCount)
            self.likesCountLabel.text = "\(tweet.favoritesCount)"
            
        }, failure: { (error:Error) in
            self.unfavorite()
        }, tweetID: tweetID)
        
        
    }
    
    func unfavorite() {
        
        self.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: UIControlState.normal)
        
        
        TwitterClient.sharedInstance?.unfavorite(success: { (tweet: Tweet) in
            print("unfavorite")
            print(tweet.favoritesCount)
            self.likesCountLabel.text = "\(tweet.favoritesCount)"
        }, failure: { (error:Error) in
            print(error.localizedDescription)
        }, tweetID: tweetID)
        
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let replyViewController = segue.destination as! ReplyViewController
        replyViewController.replyUsername = tweet.screenName
        replyViewController.replyTweetID = tweet.tweetID
        
    }
    

}

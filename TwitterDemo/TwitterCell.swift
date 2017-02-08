//
//  TwitterCell.swift
//  TwitterDemo
//
//  Created by Richard Du on 2/4/17.
//  Copyright © 2017 Richard Du. All rights reserved.
//

import UIKit

class TwitterCell: UITableViewCell {

    
    var tweetID: Int = 0
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        tweetImageView.layer.cornerRadius = 3
        tweetImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onRetweet(_ sender: AnyObject) {
        print("ID:\(tweetID)")
        
        self.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: UIControlState.normal)
        self.retweetsLabel.textColor = UIColor.green
        
        TwitterClient.sharedInstance?.retweet(success: { (tweet: Tweet) in
            print(tweet.favoritesCount)
            self.retweetsLabel.text = "\(tweet.retweetCount)"
            
            
        }, failure: { (error: Error) in
            
            print(error.localizedDescription)
        }, tweetID: tweetID)
    }
    
    @IBAction func onFavorite(_ sender: AnyObject) {
        
        self.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: UIControlState.normal)
        self.favoritesLabel.textColor = UIColor.red
        
        
        TwitterClient.sharedInstance?.favorite(success: { (tweet: Tweet) in
            print("favorite")
            print(tweet.favoritesCount)
            self.favoritesLabel.text = "\(tweet.favoritesCount)"
            
            var date = Date()
            let formatter = DateFormatter()
            formatter.timeZone = NSTimeZone.local
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let time = formatter.string(from: date)
            
            print("time:\(time)")
            
            
            print("date: \(date)")
            date = formatter.date(from: time)!
            print("updated Date: \(date)")
        }, failure: { (error:Error) in
            self.unfavorite()
        }, tweetID: tweetID)
        
        
    }
    
    func unfavorite() {
        
        self.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: UIControlState.normal)
        self.favoritesLabel.textColor = UIColor.black
        
        TwitterClient.sharedInstance?.unfavorite(success: { (tweet: Tweet) in
            print("unfavorite")
            print(tweet.favoritesCount)
            self.favoritesLabel.text = "\(tweet.favoritesCount)"
        }, failure: { (error:Error) in
            print(error.localizedDescription)
        }, tweetID: tweetID)

    }
}

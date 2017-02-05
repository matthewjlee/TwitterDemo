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
        TwitterClient.sharedInstance?.retweet(success: { (user: User) in
            
        }, failure: { (error: Error) in
            
        })
    }
    
    @IBAction func onFavorite(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.favorite(success: { (user: User) in
            
        }, failure: { (error:Error) in
            
        })
    }
}

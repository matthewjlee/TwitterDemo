//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Richard Du on 2/3/17.
//  Copyright © 2017 Richard Du. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var timestamp: String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var username: String?
    var screenName: String?
    var profileImageURL: URL?
    var tweetImageURL: URL?
    var tweetID: Int = 0
    var favoriteStatus: Bool?
    var retweetStatus: Bool?
    
    init(dictionary: NSDictionary) {
        
        print("IN TWEET")
        print(dictionary)
        
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        tweetID = (dictionary["id"] as? Int) ?? 0
        favoriteStatus = dictionary["favorited"] as? Bool
        retweetStatus = dictionary["favorited"] as? Bool
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            let retrievedDate = formatter.date(from: timestampString)!
            
            formatter.dateFormat = "d MMM YY"
            
            let elapsed = Int(Date().timeIntervalSince(retrievedDate))
            
            if elapsed/60 == 0 {
                timestamp = "\(elapsed)s"
            } else if elapsed/3600 == 0 {
                timestamp = "\(elapsed/60)m"
            } else if elapsed/86400 == 0 {
                timestamp = "\(elapsed/3600)h"
            } else if elapsed/604800 == 0 {
                timestamp = "\(elapsed/86400)d"
            } else {
                timestamp = formatter.string(from: retrievedDate)
            }
            
        }
        
        let user = dictionary["user"] as! NSDictionary
        username = user["name"] as? String
        screenName = user["screen_name"] as? String

        if let profileURLString = user["profile_image_url_https"] as? String {
            self.profileImageURL = URL(string: profileURLString)
        }
        
        let entities = dictionary["entities"] as? NSDictionary
        let media = entities?["media"] as? NSArray
        let mediaItems = media?[0] as? NSDictionary
        let tweetImageURLString = mediaItems?["media_url_https"] as? String
        
        if let tweetImageURLString = tweetImageURLString {
            self.tweetImageURL = URL(string: tweetImageURLString)
        }
        
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        return tweets
    }
}

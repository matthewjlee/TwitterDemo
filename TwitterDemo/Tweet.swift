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
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var username: String?
    var screenName: String?
    var profileURL: URL?
    var tweetURL: URL?
    
    init(dictionary: NSDictionary) {
        
        print(dictionary)
        
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        let user = dictionary["user"] as! NSDictionary
        username = user["name"] as? String
        screenName = user["screen_name"] as? String
        
        print("IN TWEET")
        print(dictionary["media_url_https"] as? String)
        let userentities = user["entities"] as? NSDictionary
        let usermedia = userentities?["media"] as? NSDictionary
        
        //if let profileURLString = dictionary["media_url_https"] as? String {
        if let profileURLString = usermedia?["media_url_https"] as? String {
            profileURL = URL(string: profileURLString)
            print(profileURLString)
        } else {
            print("NO IMAGE URL RECEIVED")
        }
        
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        
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

//
//  User.swift
//  TwitterDemo
//
//  Created by Richard Du on 2/3/17.
//  Copyright © 2017 Richard Du. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenname: String?
    var profileUrl: NSURL?
    var tagline: String?

    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as? String
    }
    
    class var currentUser: User? {
        get {
            
            let defaults = UserDefaults.standard
            
            let userData = defaults.object(forKey: "currentUserData") as? NSData
            
            if let userData = userData {
                let dictionary = try! NSJSONSerialization.JSONObject(withData:userData)
            }
            
            return user
        }
        set(user) {
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! NSJSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            
            defaults.set(user, forKey: "currentUser")
            defaults.synchronize()
            
        }
    }
}

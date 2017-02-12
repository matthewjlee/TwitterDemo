//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Richard Du on 2/3/17.
//  Copyright © 2017 Richard Du. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "mRtbeFepeScOqHGAk8lGFnGSg", consumerSecret: "yYA8NvkFYK5HHlyjpU900AWoCckGgBulSXmjoy68rUoHFq89KT")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () ->(), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil, success: {(requestToken:BDBOAuth1Credential?) -> Void in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }, failure: { (error: Error?) -> Void in
            print("error: \(error!.localizedDescription)")
            self.loginFailure?(error!)
        })
    }

    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: {(accessToken: BDBOAuth1Credential?) -> Void in
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            
            
        }, failure: {(error: Error?) -> Void
            in
            print("error: \(error?.localizedDescription)")
            self.loginFailure!(error!)
        })

    }

    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: {(task: URLSessionDataTask, response: Any?) -> Void in
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: {(task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
        
        
    }

    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: {(task: URLSessionDataTask, response: Any?) -> Void in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: {(task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func retweet(success: @escaping (Tweet) -> (), failure: @escaping (Error) -> (), tweetID: Int) {
        
        post("1.1/statuses/retweet/\(tweetID).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("retweet")
            
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            print("retweetfail")
            failure(error)
        }
    }
    
    func favorite(success: @escaping (Tweet) -> (), failure: @escaping (Error) -> (), tweetID: Int) {
        post("1.1/favorites/create.json", parameters: ["id":tweetID], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("favorited")
            
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
        }
    }
    
    func unfavorite(success: @escaping (Tweet) -> (), failure: @escaping (Error) -> (), tweetID: Int) {
        post("1.1/favorites/destroy.json", parameters: ["id":tweetID], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("unfavorited")
            
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            print("unfavorite fail")
            failure(error)
        }
    }
    
    func updateStatus(success: @escaping () -> (), failure: @escaping (Error) -> (), status: String, replyTweetID: Int?) {
        if let replyTweetID = replyTweetID {
            post("1.1/statuses/update.json", parameters: ["status": status, "in_reply_to_status_id": replyTweetID], progress: nil, success: { (task:URLSessionDataTask, response:Any?) in
                print("posted reply")
                success()
            }, failure: { (task: URLSessionDataTask?, error:Error) in
                print("reply fail")
                failure(error)
            })
            
        } else {
            post("1.1/statuses/update.json", parameters: ["status": status], progress: nil, success: { (task:URLSessionDataTask, response:Any?) in
                print("posted status")
            }, failure: { (task: URLSessionDataTask?, error:Error) in
                print("post status fail")
                failure(error)
            })
        }
    }
    
    func userTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> (), userID: Int) {
        
        get("1.1/statuses/user_timeline.json", parameters: ["user_id": userID], progress: nil, success: {(task: URLSessionDataTask, response: Any?) -> Void in
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: {(task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func userLookup(success: @escaping ([User]) -> (), failure: @escaping (Error) -> (), userID: Int) {
        get("1.1/users/lookup.json", parameters: ["user_id": userID], progress: nil, success: { (task:URLSessionDataTask, response:Any?) in
            
            let dictionaries = response as! [NSDictionary]
            let users = User.usersWithArray(dictionaries: dictionaries)
            success(users)
            
        }) { (task:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
        }
    }
}

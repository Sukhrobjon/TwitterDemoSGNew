//
//  TwitterClient.swift
//  TwitterDemoSG
//
//  Created by Sukhrobjon Golibboev on 2/20/16.
//  Copyright © 2016 ccsf. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class TwitterClient: BDBOAuth1SessionManager {
    
    
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "qiiUvXfFYFgKSAc7KRYugKvGI", consumerSecret: "vLhEmu8I53fH1n6JHF5a5VXy12qDeubOEYpa5DFUOukllnJ6nT")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    
    func login(success: () -> (), failure: (NSError) -> ())  {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "mytwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("I got token")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
       fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
        
        self.currentAccount({ (user: User) -> () in
            User.currentUser = user 
            self.loginSuccess?()
            }, failure: { (error: NSError) -> () in
            self.loginFailure?(error)
        })
            self.loginSuccess?()
 
        }) { (error: NSError!) -> Void in
                print("error:\(error.localizedDescription)")
                self.loginFailure?(error)
        }
        
    }
    
    func favoriteWithCompletion(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        POST("1.1/favorites/create.json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            var tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            
            print("This is the retweetCount: \(tweet.retweetCount)")
            print("This is the favCount: \(tweet.favoritesCount)")
            
            completion(tweet: tweet, error: nil)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("ERROR: \(error)")
                completion(tweet: nil, error: error)
        }
    }
    
    func retweetWithCompletion(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        POST("1.1/statuses/retweet/\(params!["id"] as! Int).json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            var tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            
            print("This is the retweetCount: \(tweet.retweetCount)")
            print("This is the favCount: \(tweet.favoritesCount)")
            
            //  print(tweet)
            
            completion(tweet: tweet, error: nil)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("ERROR: \(error)")
                completion(tweet: nil, error: error)
        }
    }
    
    func unRetweetWithCompletion(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        POST("1.1/statuses/unretweet/\(params!["id"] as! Int).json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            var tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            
            
            completion(tweet: tweet, error: nil)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("ERROR: \(error)")
                completion(tweet: nil, error: error)
        }
    }

    
    func homeTimeline (success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
    }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        })

        
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ())  {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
        
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
                
        })

        
            }
    
    func sendTweet(status: String, params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/statuses/update.json?status=\(status)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("Sent a tweet")
            completion(error: nil)
            }, failure:  { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Couldn't send a tweet...")
                completion(error: error)
            }
        )
    }
    
}




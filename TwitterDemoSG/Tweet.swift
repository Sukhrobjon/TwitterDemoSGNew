//
//  Tweet.swift
//  TwitterDemoSG
//
//  Created by Sukhrobjon Golibboev on 2/20/16.
//  Copyright © 2016 ccsf. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var id: NSNumber?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var retweetImage: UIImage?
    var favImage: UIImage?
    
    
    init(dictionary: NSDictionary) {
        
        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        text = dictionary["text"] as? String
        
        createdAtString = dictionary["created_at"] as? String
        
        id = dictionary["id"] as? Int
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        
        favoritesCount = (dictionary["favorites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let  formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createdAt = formatter.dateFromString(createdAtString!)
        }
    }
    
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]  {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries  {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
    return tweets
    
    }
    class func tweetAsDictionary(dict: NSDictionary) -> Tweet {
        
        var tweet = Tweet(dictionary: dict)
        
        return tweet
    }

    
    
}

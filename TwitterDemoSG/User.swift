//
//  User.swift
//  TwitterDemoSG
//
//  Created by Sukhrobjon Golibboev on 2/20/16.
//  Copyright © 2016 ccsf. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenname: NSString?
    var profileImageUrl: NSURL?
    var tagline: NSString?
    var favCount: Int?
    
    var dictionary: NSDictionary?
    
    var profileBackgroundImageUrl: NSURL?
    var numFollowers: Int?
    var numFollowing: Int?
    var numTweets: Int?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
        
        let profileImageUrlString = dictionary["profile_image_url_https"] as? String
        if let profileImageUrlString = profileImageUrlString {
            profileImageUrl = NSURL(string: profileImageUrlString)
        }
        
    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    static var _currentUser: User?
    
    func logout () {
        print(User.currentUser)
        User.currentUser = nil;
        print(User.currentUser)
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken();
        print("is this getting called?")
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil);
    }
    
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
        
            let defaults = NSUserDefaults.standardUserDefaults()
            
            let userData = defaults.objectForKey("currentUserData") as? NSData
        
            if let userData = userData {
                 let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                _currentUser = User(dictionary: dictionary)
                }
        
        }
            return _currentUser
    }

        
        set(user) {
            _currentUser = user 
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            
            if let user = user {
            let data = try!NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
 
                
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                 defaults.setObject(nil, forKey: "currentUserData")
            }
           
    defaults.synchronize()
            }
  
}
}

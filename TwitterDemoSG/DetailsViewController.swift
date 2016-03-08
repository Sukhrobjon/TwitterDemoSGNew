//
//  DetailsViewController.swift
//  TwitterDemoSG
//
//  Created by Sukhrobjon Golibboev on 3/7/16.
//  Copyright © 2016 ccsf. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var numRetweetsLabel: UILabel!
    @IBOutlet weak var numLikesLabel: UILabel!
    
    @IBOutlet weak var tweetTextView: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var numTweetsLabel: UILabel!
    @IBOutlet weak var numFollowersLabel: UILabel!
    @IBOutlet weak var numFollowingLabel: UILabel!
    
    var tweet: Tweet!
    var tweetID: NSNumber?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(tweet)
        nameLabel.text = tweet.user!.name
        screenNameLabel.text = "@\(tweet.user!.screenname!)"
        tweetTextView.text = tweet.text
        thumbImageView.setImageWithURL(tweet.user!.profileImageUrl!)
        timeAgoLabel.text = calculateTimeStamp(tweet.createdAt!.timeIntervalSinceNow)
        tweetID = tweet.id
        numRetweetsLabel.text = String(tweet.retweetCount)
        numLikesLabel.text = String(tweet.favoritesCount)
        
        nameLabel.text = tweet.user!.name!
        screenNameLabel.text = "@\(tweet.user!.screenname!)"
        numTweetsLabel.text = String(tweet.user!.numTweets!)
        numFollowersLabel.text = String(tweet.user!.numFollowers!)
        numFollowingLabel.text = String(tweet.user!.numFollowing!)
        
        thumbImageView.setImageWithURL(tweet.user!.profileImageUrl!)
        backgroundImageView.setImageWithURL(tweet.user!.profileBackgroundImageUrl!)
        
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculateTimeStamp(timeTweetPostedAgo: NSTimeInterval) -> String {
        // Turn timeTweetPostedAgo into seconds, minutes, hours, days, or years
        var rawTime = Int(timeTweetPostedAgo)
        var timeAgo: Int = 0
        var timeChar = ""
        
        rawTime = rawTime * (-1)
        
        // Figure out time ago
        if (rawTime <= 60) { // SECONDS
            timeAgo = rawTime
            timeChar = "s"
        } else if ((rawTime/60) <= 60) { // MINUTES
            timeAgo = rawTime/60
            timeChar = "m"
        } else if (rawTime/60/60 <= 24) { // HOURS
            timeAgo = rawTime/60/60
            timeChar = "h"
        } else if (rawTime/60/60/24 <= 365) { // DAYS
            timeAgo = rawTime/60/60/24
            timeChar = "d"
        } else if (rawTime/(60/60/24/365) <= 1) { // ROUGH ESTIMATE OF YEARS
            timeAgo = rawTime/60/60/24/365
            timeChar = "y"
        }
        
        return "\(timeAgo)\(timeChar)"
    }
}

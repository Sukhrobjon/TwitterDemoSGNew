//
//  TweetCell.swift
//  TwitterDemoSG
//
//  Created by Sukhrobjon Golibboev on 2/21/16.
//  Copyright © 2016 ccsf. All rights reserved.
//

import UIKit
import AFNetworking


class TweetCell: UITableViewCell {

 
    @IBOutlet weak var favCountLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var replyImageView: UIImageView!
    
    
    
    var tweetID: NSNumber?
    
    var tweet : Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            nameLabel.text = tweet.user!.name
            screennameLabel.text = "@\(tweet.user?.screenname)"
            
            retweetCountLabel.text = "\(tweet.retweetCount as! Int)"
            
            favCountLabel.text = "\(tweet.favoritesCount as! Int)"
            
            profileImageView.setImageWithURL(tweet.user!.profileImageUrl!)
            
            timeLabel.text = calculateTimeStamp(tweet.createdAt!.timeIntervalSinceNow)
            
            tweetID = tweet.id
        }
    }
    
    //All credit for this method goes to David Wayman, slack @dwayman
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
        } else if (rawTime/(3153600) <= 1) { // YEARS
            timeAgo = rawTime/60/60/24/365
            timeChar = "y"
        }
        
        return "\(timeAgo)\(timeChar)"
    }
    
    @IBAction func retweetButtonClicked(sender: AnyObject) {
        
        print("Retweet button clicked")
        
        TwitterClient.sharedInstance.retweetWithCompletion(["id": tweetID!]) { (tweet, error) -> () in
            
            if (tweet != nil) {
                
                self.retweetButton.setImage(UIImage(named: "retweet-action-on-green.png"), forState: UIControlState.Normal)
                
                if self.retweetCountLabel.text! > "0" {
                    self.retweetCountLabel.text = String(self.tweet!.retweetCount + 1)
                } else {
                    self.retweetCountLabel.hidden = false
                    self.retweetCountLabel.text =
                        String(self.tweet!.retweetCount + 1)
                }
                
            }
            else {
                print("ERROR retweeting: \(error)")
            }
        }
    }
    
    @IBAction func likeButtonClicked(sender: AnyObject) {
        
        print("Like button clicked")
        
        TwitterClient.sharedInstance.favoriteWithCompletion(["id": tweetID!]) { (tweet, error) -> () in
            
            if (tweet != nil) {
                
                self.favButton.setImage(UIImage(named: "like-action-on-red.png"), forState: UIControlState.Normal)
                
                if self.favCountLabel.text! > "0" {
                    self.favCountLabel.text = String(self.tweet.favoritesCount + 1)
                } else {
                    self.favCountLabel.hidden = false
                    self.favCountLabel.text = String(self.tweet.favoritesCount + 1)
                }
                
            }
            else {
                print("Did it print the print fav tweet? cause this is the error message and you should not be seeing this.")
            }
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

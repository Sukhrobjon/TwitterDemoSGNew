//
//  TweetsViewController.swift
//  TwitterDemoSG
//
//  Created by Sukhrobjon Golibboev on 2/20/16.
//  Copyright © 2016 ccsf. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet]?
    
    
     @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate =  self
        tableView.dataSource = self
        
        //set tableviewcell row height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        
        
  TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
    
    //if tweets != nil {
        self.tweets = tweets
        self.tableView.reloadData()
    //}
    
    for tweet in tweets  {
        print(tweet.text)
        }
                
    }, failure: { (error: NSError) -> () in
        print(error.localizedDescription)
            })
            
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        if (tweets != nil) {
            cell.tweet = tweets![indexPath.row]
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

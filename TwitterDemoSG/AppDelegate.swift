//
//  AppDelegate.swift
//  TwitterDemoSG
//
//  Created by Sukhrobjon Golibboev on 2/19/16.
//  Copyright © 2016 ccsf. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var storyboard = UIStoryboard(name: "Main", bundle: nil)
    let tabBarController = UITabBarController()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogout", name: User.userDidLogoutNotification, object: nil)
        
        
        if (User.currentUser != nil) {
            // GO to the logged in screen
            print("Current User detected")
            
            // User.currentUser = nil
            //userDidLogout()
            setupTabBars()
            
        } else {
            print("no user found")
            var vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as? UIViewController
            // Make the vc the root view controller
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
            
            //setupTabBars()
        }
        
        return true
    }
    
    func userDidLogout() {
        print("trying to log user out and switch view controllers as well")
        var vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as? UIViewController
        window?.rootViewController = vc
    }
    
    func setupTabBars() {
        // Set up the search View Controller
        let tweetsNavigationController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
        let tweetsViewController = tweetsNavigationController.topViewController as! TweetsViewController
        tweetsNavigationController.tabBarItem.title = "Home"
        tweetsNavigationController.tabBarItem.image = UIImage(named: "home")
        
        
        //Customize Popular navigation bar UI
        //tweetsNavigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(rgba: "#55acee").CGColor]
        
        /* Create an Image View to replace the Title View */
        var imageView: UIImageView = UIImageView(frame: CGRectMake(0.0, 0.0, 40.0, 40.0))
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        /* Load an image. Be careful, this image will be cached */
//        var image: UIImage = UIImage(named: "Icon-Small-50")!
        
        /* Set the image of the Image View */
//        imageView.image = image
        
        /* Set the Title View */
        tweetsNavigationController.navigationBar.topItem?.titleView = imageView
        
        // Set up the search View Controller
        let meViewController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController")
        meViewController.tabBarItem.title = "Me"
        meViewController.tabBarItem.image = UIImage(named: "profile")
        
        // Set up the Tab Bar Controller to have two tabs
        tabBarController.viewControllers = [tweetsNavigationController, meViewController]
        //UITabBar.appearance().tintColor = UIColor(rgba: "#55acee")
        //    UITabBar.appearance().barTintColor = UIColor.blackColor()
        
        // Make the Tab Bar Controller the root view controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        TwitterClient.sharedInstance.handleOpenUrl(url)
        
        return true
    }
}

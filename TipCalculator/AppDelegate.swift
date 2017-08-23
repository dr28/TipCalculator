//
//  AppDelegate.swift
//  TipCalculator
//
//  Created by Deepthy on 8/9/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var appStartTime : NSDate? = nil
    var inActivityStartTime : Any? = nil

    let defaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        defaults.removeObject(forKey: "APP_INACTIVITY_START")
        
        let theme = ThemeManager.currentTheme()
        ThemeManager.applyTheme(theme: theme)
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        appInactive()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

        appActive()

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }
    
    func appActive ()
    {
        appStartTime = NSDate()
        
        inActivityStartTime = defaults.object(forKey: "APP_INACTIVITY_START")
        
        if (inActivityStartTime != nil) {
            
            trackTime(appStart: appStartTime, inactivityStart: inActivityStartTime as? NSDate)
        }
        
        
    }
    
    func appInactive ()
    {
        inActivityStartTime = NSDate()
        
        defaults.set(inActivityStartTime, forKey: "APP_INACTIVITY_START")
        
    }
    
    func trackTime(appStart: NSDate?, inactivityStart: NSDate?) {
        
        if ((appStart!.timeIntervalSinceReferenceDate - inactivityStart!.timeIntervalSinceReferenceDate) > 600) {

            resetApp()
        }
    }
    
    func resetApp()
    {
        
        if let viewController = window?.rootViewController?.childViewControllers[0] as? ViewController {
        
            viewController.billText.text = ""
            viewController.taxText.text = ""
            
            viewController.tipLabel.text = viewController.localeSpecificCurrencySymbol?.appending("0.00")
            viewController.totalLabel.text = viewController.localeSpecificCurrencySymbol?.appending("0.00")
            viewController.totalPerPerson.text = viewController.localeSpecificCurrencySymbol?.appending("0.00")
            viewController.tipPerPerson.text = viewController.localeSpecificCurrencySymbol?.appending("0.00")
            

            //UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)

            viewController.viewWillAppear(true)
        }
        
        
    }



}


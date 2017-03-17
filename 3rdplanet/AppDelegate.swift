//
//  AppDelegate.swift
//  3rdplanet
//
//  Created by zeus on 2/7/17.
//  Copyright © 2017 justzeus. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
            if !granted {
                print("Notification access has been denied.")
            }
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        PostController.sharedController.performFullSync()
    }
}

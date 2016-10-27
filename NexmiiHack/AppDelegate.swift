//
//  AppDelegate.swift
//  NexmiiHack
//
//  Created by Or on 27/10/2016.
//  Copyright © 2016 Or. All rights reserved.
//

import UIKit
import Firebase
import OneSignal
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //OneSignal.initWithLaunchOptions(launchOptions, appId: "f5920934-0fb0-4bea-8079-46ecb3238464")
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: "f5920934-0fb0-4bea-8079-46ecb3238464", handleNotificationReceived: { (notification) in
                print("Received Notification - \(notification?.payload.notificationID)")
            },
                handleNotificationAction: { (result) in
                
                // This block gets called when the user reacts to a notification received
                let payload = result?.notification.payload
                var fullMessage = payload?.title
                
                //Try to fetch the action selected
                if let additionalData = payload?.additionalData, let actionSelected = additionalData["actionSelected"] as? String {
                    fullMessage =  fullMessage! + "\nPressed ButtonId:\(actionSelected)"
                }
                print(fullMessage)
            }, settings: [kOSSettingsKeyAutoPrompt : false, kOSSettingsKeyInFocusDisplayOption : 0])
        
    
    
        //FIRApp.configure()
        
        Translate.to(.es,fromLang:.en, text: "I like milk and pizza") { str in
            print(str)
            OneSignal.postNotification(["contents": ["en": str], "include_player_ids": ["0f23a9c1-e65f-4e2a-91b4-c022ce335ee9"]])
        }
       
        
        return true
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("GOT IT")
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


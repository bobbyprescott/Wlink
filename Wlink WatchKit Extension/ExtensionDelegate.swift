//
//  ExtensionDelegate.swift
//  Wlink WatchKit Extension
//
//  Created by robert prescott on 11/27/19.
//  Copyright © 2019 bobcode. All rights reserved.
//

import WatchKit
import UserNotifications
import SwiftUI

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    let mess = Mess()

    func applicationDidFinishLaunching() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound]) {(granted, error) in
            if (granted){
                WKExtension.shared().registerForRemoteNotifications()
            } else { /* handle no access */}
        }
        
    }
    
    func didReceiveRemoteNotification(_ userInfo: [AnyHashable : Any],
                                      fetchCompletionHandler: @escaping (WKBackgroundFetchResult) -> Void){
        let arr = "\(userInfo)".split(separator: "*")
        mess.messTitle = String(arr[1])
        fetchCompletionHandler(.newData)
        
    }
    
    func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data){
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        let temp = UserDefaults.standard
        if temp.value(forKey: "NotificationID") == nil{
            temp.setValue("\(token)", forKey: "NotificationID")
        }
        temp.synchronize()
        print("token \(token)")
    }
    
    func didFailToRegisterForRemoteNotificationsWithError(_ error: Error){
         print("failed \(error)")
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }

}

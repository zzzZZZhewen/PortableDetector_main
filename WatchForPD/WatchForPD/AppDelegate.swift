//
//  AppDelegate.swift
//  WatchForPD
//
//  Created by 缪哲文 on 16/1/28.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit
import WatchConnectivity


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var recordsDataModel: [WatchRecordModel]?
    let dataManager = WatchDataManager()
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            WatchSessionManager.sharedManager.startSession()
        } else {
            print("WCSession not supported")
        }
        //监听watch动作
        dataManager.listenCommand("pullStatus") { (message, replyHandler) -> Void in
            replyHandler(["canGetStatus": false])
        }
        dataManager.listenCommand("pullRecord") {[weak self] (message, replyHandler) -> Void in

            if let strongSelf = self {
                let number = message["number"] as! Int
                var reply = strongSelf.dataManager.getRecordWithNumber(number)
                reply["canGetRecord"] = true
                replyHandler(reply)
            }
            
        }
        dataManager.listenCommand("pushStart") { (message, replyHandler) -> Void in
            replyHandler(["canPushStart": false])
        }
        dataManager.listenCommand("pushStop") { (message, replyHandler) -> Void in
            replyHandler(["canPushStop": false])
        }
        dataManager.listenCommand("deleteRecord") { (message, replyHandler) -> Void in
            
            replyHandler(["canDeleteRecord": true])
        }
        dataManager.listenCommand("printRecord") { (message, replyHandler) -> Void in
            replyHandler(["canPrintRecord": false])
        }
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
        return true
    }
    
}
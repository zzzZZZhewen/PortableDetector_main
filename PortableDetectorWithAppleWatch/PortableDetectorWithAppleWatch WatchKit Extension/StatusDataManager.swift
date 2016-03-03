//
//  StatusDataManager.swift
//  WatchForPD
//
//  Created by 缪哲文 on 16/1/31.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import WatchKit



class StatusDataManager: NSObject {
    
    func getLastStatus()-> [String: AnyObject]? {
        return SessionManager.sharedManager.getLastReceivedApplicationContext()
    }
    
    func pullStatus(replyHandler: ([String : AnyObject]) -> Void, errorHandler: (String) -> Void) {
        SessionManager.sharedManager.request(["command" : "pullStatus"], replyHandler: { (reply) -> Void in
            replyHandler(reply)
        }) { (errorDescription) -> Void in
            errorHandler(errorDescription)
        }
    }
    
    func pullRecordsWithNumber(number: Int?, replyHandler: ([String : AnyObject]) -> Void, errorHandler: (String) -> Void) {
        SessionManager.sharedManager.request(["command": "pullRecord", "number": number != nil ? number! : 5], replyHandler: { (reply) -> Void in
            replyHandler(reply)
        }) { (errorDescription) -> Void in
            errorHandler(errorDescription)
        }
    }
    
    func pushStart(replyHandler: ([String : AnyObject]) -> Void, errorHandler: (String) -> Void) {
        SessionManager.sharedManager.request(["command" : "pushStart"], replyHandler: { (reply) -> Void in
            replyHandler(reply)
        }) { (errorDescription) -> Void in
            errorHandler(errorDescription)
        }
    }
    
    func pushStop(replyHandler: ([String : AnyObject]) -> Void, errorHandler: (String) -> Void) {
        SessionManager.sharedManager.request(["command" : "pushStop"], replyHandler: { (reply) -> Void in
            replyHandler(reply)
        }) { (errorDescription) -> Void in
            errorHandler(errorDescription)
        }
    }

    func listenUpdateStatus(handler: ([String: AnyObject])->Void) {
        SessionManager.sharedManager.didReceiveApplicationContextHandler = handler
    }
    
    func listenMessage(messageType: String, handler: ([String:AnyObject]) -> Void) {
        SessionManager.sharedManager.setDidReceiveMessageHandler(handler, forMessageType: messageType)
    }

}
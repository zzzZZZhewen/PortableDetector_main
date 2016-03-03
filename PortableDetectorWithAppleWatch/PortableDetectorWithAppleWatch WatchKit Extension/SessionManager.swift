//
//  SessionManager.swift
//  WatchForPD
//
//  Created by 缪哲文 on 16/2/1.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import Foundation
import WatchConnectivity

class SessionManager: NSObject {
    
    private static let instance = SessionManager()
    
    class var sharedManager: SessionManager {
        return instance
    }
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }
    
    var didReceiveApplicationContextHandler: (([String: AnyObject])->Void)?
    
    var didReceiveMessageHandlerForMessageType: [String:([String:AnyObject]) -> Void]?
    
    /// MARK - life circle
    
    deinit {
        print("Session Manager farewell")
    }
    
    /// MARK - public services
    
    func startSession() {
        self.session = WCSession.defaultSession()
    }
    
    func setDidReceiveMessageHandler(handler:([String:AnyObject]) -> Void, forMessageType messageType: String) {
        if didReceiveMessageHandlerForMessageType != nil {
            self.didReceiveMessageHandlerForMessageType![messageType] = handler
        } else {
            self.didReceiveMessageHandlerForMessageType = [messageType: handler]
        }
    }

    
    func request(request: [String: AnyObject], replyHandler: ([String : AnyObject]) -> Void, errorHandler: (String) -> Void ) {
        if session != nil {
            if session!.reachable {
                session!.sendMessage(request, replyHandler: { (reply: [String : AnyObject]) -> Void in
                    replyHandler(reply)
                }, errorHandler: { (error: NSError) -> Void in
                    errorHandler(error.description)
                })
            } else if session!.iOSDeviceNeedsUnlockAfterRebootForReachability {
                errorHandler("需要解锁手机才能联络到手机")
            } else {
                errorHandler("未知错误无法联系到手机")
            }
        }else {
            errorHandler("不支持的通信")
        }
    }
    
    func getLastReceivedApplicationContext() -> [String:AnyObject]? {
        if let session = session {
            return session.receivedApplicationContext
        } else {
            return nil
        }
    }
    
   
}
/// MARK - WCSessionDelegate
extension SessionManager: WCSessionDelegate {
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        if let handler = didReceiveApplicationContextHandler {
            handler(applicationContext)
            
        }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        if let messageType = message["messageType"] as? String {
            if let handler = didReceiveMessageHandlerForMessageType?[messageType] {
                handler(message)
            } else {
                // 对相应command无响应
            }
        } else {
            //非指令message
        }
    }
}
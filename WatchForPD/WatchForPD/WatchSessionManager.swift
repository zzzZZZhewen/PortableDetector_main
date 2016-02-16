//
//  WatchSessionManager.swift
//  WatchForPD
//
//  Created by 缪哲文 on 16/2/1.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit
import WatchConnectivity


class WatchSessionManager: NSObject {
    
    private static let instance = WatchSessionManager()
    
    class var sharedManager: WatchSessionManager {
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
    
    var didReceiveMessageHandlerForCommandString: [String:([String:AnyObject],([String : AnyObject]) -> Void) -> Void]?
    
    func setDidReceiveMessageHandler(handler:([String:AnyObject],([String : AnyObject]) -> Void) -> Void, forCommand command: String) {
        if didReceiveMessageHandlerForCommandString != nil {
            self.didReceiveMessageHandlerForCommandString![command] = handler
        } else {
            self.didReceiveMessageHandlerForCommandString = [command: handler]
        }
    }
    
    func startSession() {
        self.session = WCSession.defaultSession()
    }
    
    func updateApplicationContext(context: [String : AnyObject]){
        do {
            try session!.updateApplicationContext(context)
        } catch {
            print(error)
        }
    }
    
    func request(request: [String: AnyObject]) {
        if session != nil {
            if session!.reachable {
                session!.sendMessage(request, replyHandler: nil , errorHandler: nil)
            } else {
                //errorHandler("无法联系到手表")
            }
        }else {
            //errorHandler("不支持的通信")
        }
    }
}

extension WatchSessionManager: WCSessionDelegate {
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        if let commandString = message["command"] as? String {
            if let handler = didReceiveMessageHandlerForCommandString?[commandString] {
                handler(message, replyHandler)
            } else {
                // 对相应command无响应
            }
        } else {
            //非指令message
        }
    }
    
    func sessionReachabilityDidChange(session: WCSession) {
        
    }
    
    func sessionWatchStateDidChange(session: WCSession) {
        //暂时看来没有必要响应这个
    }
}
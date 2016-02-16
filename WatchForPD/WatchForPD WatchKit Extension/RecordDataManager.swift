//
//  RecordDataManager.swift
//  WatchForPD
//
//  Created by 缪哲文 on 16/2/6.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import WatchKit

class RecordDataManager: NSObject {
    func deleteRecordWithPlateString(plateString:String, replyHandler: ([String : AnyObject]) -> Void, errorHandler: (String) -> Void) {
        SessionManager.sharedManager.request(["command" : "deleteRecord", "plate" : plateString], replyHandler: { (reply) -> Void in
            replyHandler(reply)
            }) { (errorDescription) -> Void in
                errorHandler(errorDescription)
        }
    }
    
    func printRecordWithPlateString(plateString:String, replyHandler: ([String : AnyObject]) -> Void, errorHandler: (String) -> Void) {
        SessionManager.sharedManager.request(["command" : "printRecord", "plate" : plateString], replyHandler: { (reply) -> Void in
            replyHandler(reply)
            }) { (errorDescription) -> Void in
                errorHandler(errorDescription)
        }
    }

}

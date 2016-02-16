//
//  WatchDataManager.swift
//  WatchForPD
//
//  Created by 缪哲文 on 16/2/1.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit

class WatchDataManager: NSObject {
    
    
    func updateWatchStatusWithDataModelDict(dict: [String: AnyObject]) {
        WatchSessionManager.sharedManager.updateApplicationContext(dict)
    }
    
    func listenCommand(command: String, handler: ([String:AnyObject],([String : AnyObject]) -> Void) -> Void) {
        WatchSessionManager.sharedManager.setDidReceiveMessageHandler(handler, forCommand: command)
    }
    
    func sendWatchMessage(messageType: String, message: [String: AnyObject]?) {
        var request: [String: AnyObject] = ["messageType": messageType]
        if var message = message {
            message["messageType"] = messageType
            request = message
        }
        WatchSessionManager.sharedManager.request(request)
    }

    func getRecordWithNumber(number: Int) -> [String: AnyObject] {
        
        var result: [String: AnyObject] = ["numberOfRecords": 6]
        let record0 = WatchRecordModel(plateString: "浙A1654332", axleTypeString: "一轴车", speedString: "3.4KM/H", weightString: "100.0T", overWeigthString: "80.0T", datetimeString: "2016-01-01 12:31:29", isOverWeight: true)
        let record1 = WatchRecordModel(plateString: "浙A123456", axleTypeString: "一轴车", speedString: "3.4KM/H", weightString: "100.0T", overWeigthString: "80.0T", datetimeString: "2016-01-01 12:31:29", isOverWeight: true)
        let record2 = WatchRecordModel(plateString: "陕C123456", axleTypeString: "二轴车", speedString: "3.4KM/H", weightString: "100.0T", overWeigthString: "80.0T", datetimeString: "2016-01-01 12:31:29", isOverWeight: false)
        let record3 = WatchRecordModel(plateString: "陕A123456", axleTypeString: "三轴车", speedString: "3.4KM/H", weightString: "100.0T", overWeigthString: "80.0T", datetimeString: "2016-01-01 12:31:29", isOverWeight: true)
        let record4 = WatchRecordModel(plateString: "陕B123456", axleTypeString: "四轴车", speedString: "3.4KM/H", weightString: "100.0T", overWeigthString: "80.0T", datetimeString: "2016-01-01 12:31:29", isOverWeight: false)
        let record5 = WatchRecordModel(plateString: "陕D123456", axleTypeString: "五轴车", speedString: "3.4KM/H", weightString: "100.0T", overWeigthString: "80.0T", datetimeString: "2016-01-01 12:31:29", isOverWeight: true)
        
        
        result["records"] = [record0.dictFromObject(), record1.dictFromObject(), record2.dictFromObject(), record3.dictFromObject(), record4.dictFromObject(), record5.dictFromObject()]
        
        return result
    }
}

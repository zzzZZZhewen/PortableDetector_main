//
//  RecordModel.swift
//  WatchForPD
//
//  Created by 缪哲文 on 16/1/31.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import Foundation

class WatchRecordModel: NSObject {
    var plateString: String = "未知车牌"
    var axleTypeString: String = "未知轴型"
    var speedString: String = "未知车速"
    var weightString: String = "未知重量"
    var overWeigthString: String = "未知超重"
    var datetimeString: String = "未知日期"
    var isOverWeight = false
    
    override init() {
    }
    
    convenience init(plateString: String, axleTypeString: String, speedString: String, weightString: String, overWeigthString: String, datetimeString: String, isOverWeight: Bool) {
        self.init()
        self.plateString = plateString
        self.axleTypeString = axleTypeString
        self.speedString = speedString
        self.weightString = weightString
        self.overWeigthString = overWeigthString
        self.datetimeString = datetimeString
        self.isOverWeight = isOverWeight
    }
    
    func dictFromObject() ->[String: AnyObject] {
        let dict: [String : AnyObject] = [
            "plateString": plateString,
            "axleTypeString":axleTypeString,
            "speedString": speedString,
            "weightString": weightString,
            "overWeigthString": overWeigthString,
            "datetimeString": datetimeString,
            "isOverWeight": isOverWeight]
        
        return dict
    }
    
    class func objectFromDict(dict: [String: AnyObject]) ->WatchRecordModel? {
        let object = WatchRecordModel()
        if let plateString = dict["plateString"] as? String,
            let axleTypeString = dict["axleTypeString"] as? String,
            let speedString = dict["speedString"] as? String,
            let weightString = dict["weightString"] as? String,
            let overWeigthString = dict["overWeigthString"] as? String,
            let datetimeString = dict["datetimeString"] as? String,
            let isOverWeight = dict["isOverWeight"] as? Bool{
                object.plateString = plateString
                object.axleTypeString = axleTypeString
                object.speedString = speedString
                object.weightString = weightString
                object.overWeigthString = overWeigthString
                object.datetimeString = datetimeString
                object.isOverWeight = isOverWeight
        }
        
        return object
    }

}

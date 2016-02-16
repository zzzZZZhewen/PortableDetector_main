//
//  StatusModel.swift
//  WatchForPD
//
//  Created by 缪哲文 on 16/1/31.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import Foundation

class WatchStatusModel: NSObject {
    var isTesting = false
    var balanceABatteryLevel = 0
    var balanceBBatteryLevel = 0
    var balanceASignalLevel = 0
    var balanceBSignalLevel = 0
    var isInstrumentConnected = false
    var isAutomobileExisted = false
    
    override init() {
    }
    
    convenience init(isTesting: Bool, balanceABatteryLevel: Int, balanceBBatteryLevel: Int, balanceASignalLevel: Int, balanceBSignalLevel: Int, isInstrumentConnected: Bool, isAutomobileExisted: Bool) {
        self.init()
        self.isTesting = isTesting
        self.balanceABatteryLevel = balanceABatteryLevel
        self.balanceBBatteryLevel = balanceBBatteryLevel
        self.balanceASignalLevel = balanceASignalLevel
        self.balanceBSignalLevel = balanceBSignalLevel
        self.isInstrumentConnected = isInstrumentConnected
        self.isAutomobileExisted = isAutomobileExisted
    }
    
    func dictFromObject() ->[String: AnyObject] {
        let dict: [String : AnyObject] = ["isTesting": isTesting,
            "balanceABatteryLevel":balanceABatteryLevel,
            "balanceBBatteryLevel": balanceBBatteryLevel,
            "balanceASignalLevel": balanceASignalLevel,
            "balanceBSignalLevel": balanceBSignalLevel,
            "isInstrumentConnected": isInstrumentConnected,
            "isAutomobileExisted": isAutomobileExisted]
        
        return dict
    }
    
    class func objectFromDict(dict: [String: AnyObject]) ->WatchStatusModel? {
        let object = WatchStatusModel()
        if let isTesting = dict["isTesting"] as? Bool,
        let balanceABatteryLevel = dict["balanceABatteryLevel"] as? Int,
        let balanceBBatteryLevel = dict["balanceBBatteryLevel"] as? Int,
        let balanceASignalLevel = dict["balanceASignalLevel"] as? Int,
        let balanceBSignalLevel = dict["balanceBSignalLevel"] as? Int,
        let isInstrumentConnected = dict["isInstrumentConnected"] as? Bool,
        let isAutomobileExisted = dict["isAutomobileExisted"] as? Bool {
            object.isTesting = isTesting
            object.balanceABatteryLevel = balanceABatteryLevel
            object.balanceBBatteryLevel = balanceBBatteryLevel
            object.balanceASignalLevel = balanceASignalLevel
            object.balanceBSignalLevel = balanceBSignalLevel
            object.isInstrumentConnected = isInstrumentConnected
            object.isAutomobileExisted = isAutomobileExisted
        }
        
        return object
    }
    
}

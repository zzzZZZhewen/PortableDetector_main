//
//  ViewModel.swift
//  WatchForPD
//
//  Created by 缪哲文 on 16/2/3.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit

class ViewModel: NSObject {

    var dataManager = WatchDataManager()
    var dataModel: WatchStatusModel?
    
    override init() {
        super.init()
        dataManager.listenCommand("pullStatus") { [weak self] (message, replyHandler) -> Void in
            if let strongSelf = self where strongSelf.dataModel != nil {
                var dict = strongSelf.dataModel!.dictFromObject()
                dict["canGetStatus"] = true
                
                replyHandler(dict)
            } else {
                replyHandler(["canGetStatus": false])
            }
        }
        dataManager.listenCommand("pushStart") { [weak self] (message, replyHandler) -> Void in
            if let strongSelf = self where strongSelf.dataModel != nil {
                // 在这里设置开始 然后回传状态
                
                var dict = strongSelf.dataModel!.dictFromObject()
                dict["canPushStart"] = true
                
                replyHandler(dict)
            } else {
                replyHandler(["canPushStart": false])
            }
        }
        dataManager.listenCommand("pushStop") { [weak self] (message, replyHandler) -> Void in
            if let strongSelf = self where strongSelf.dataModel != nil {
                // 在这里设置停止 然后回传状态
                
                var dict = strongSelf.dataModel!.dictFromObject()
                dict["canPushStop"] = true
                
                replyHandler(dict)
            } else {
                replyHandler(["canGetStop": false])
            }
        }
    }
    
    func startTesting() {
        //现实情况应该由其他dataManager提供这个dataModel
        
        let isTesting = (arc4random() % 2 == 0) ? false : true
        let balanceBatteryLevel = Int(arc4random() % 4)
        let balanceSignalLevel = Int(arc4random() % 5)
        
        
        let statusDataModel = WatchStatusModel.init(isTesting: isTesting, balanceABatteryLevel: balanceBatteryLevel, balanceBBatteryLevel: balanceBatteryLevel, balanceASignalLevel: balanceSignalLevel, balanceBSignalLevel: balanceSignalLevel, isInstrumentConnected: isTesting, isAutomobileExisted: isTesting)
        self.dataModel = statusDataModel
        
        var dict = self.dataModel!.dictFromObject()
        dict["canGetStatus"] = true
        dataManager.updateWatchStatusWithDataModelDict(dict)
        // set did receive handler
    }
    
    func pushRecord() {
        dataManager.sendWatchMessage("pushRecord", message: WatchRecordModel(plateString: "浙A1654332", axleTypeString: "一轴车", speedString: "3.4KM/H", weightString: "100.0T", overWeigthString: "80.0T", datetimeString: "2016-01-01 12:31:29", isOverWeight: true).dictFromObject())
    }
    
    func clear() {
        
        self.dataModel = nil
        dataManager.updateWatchStatusWithDataModelDict(["canGetStatus": false])
    }
    
}

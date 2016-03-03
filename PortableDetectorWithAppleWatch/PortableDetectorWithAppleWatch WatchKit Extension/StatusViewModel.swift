//
//  StatusViewModel.swift
//  WatchForPD
//
//  Created by 缪哲文 on 16/1/31.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import WatchKit

@objc protocol StatusViewModelDelegate {
    func didUpdateStatusViewModel()
    func didOccurErrorWithDescription(description: String)
    func didReceivedNewRecordWithPlateString(plateString: String, description: String)
    func didPullRecordContexts()
}

class StatusViewModel: NSObject {
    weak var delegate: StatusViewModelDelegate?
    var alertBlock = false
    // dataModel = nil 的初始状态
    var isValidStatus = false 
    var isTesting = false
    var balanceABatteryString = TNFontIcon.batteryStatus[0].rawValue
    var balanceASignaString = TNFontIcon.signalStatus[0].rawValue
    var balanceBBatteryString = TNFontIcon.batteryStatus[0].rawValue
    var balanceBSignalString = TNFontIcon.signalStatus[0].rawValue
    var instrumentConnectionString = TNFontIcon.LanDisConnected.rawValue
    var automobileStatusString = "未知"
    
    var dataModel: WatchStatusModel?
    var recordsDataModel: [WatchRecordModel]?
    
    var receivedUnshownRecord = [WatchRecordModel]()
    var dataManager = StatusDataManager()
    
    
    override init() {
        super.init()
        self.setObserver()
        
        // 跑一个循环来查看是否有记录收到以后没有显示过
        let timer = NSTimer.init(timeInterval: 2.0, target: self, selector: "scanReceivedUnshownRecord:", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)

    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /// MARK - Services
    
    func getLastStatus() {
        let context = dataManager.getLastStatus()
        if let canGetStatus = context?["canPullStatus"] as? Bool {
            if canGetStatus {
                self.dataModel = WatchStatusModel.objectFromDict(context!)
            } else {
                // 暂时无法获得状态
                self.dataModel = nil
            }
        } else {
            self.dataModel = nil
        }
        
        self.updateStatus()
    }
    
    func listenUpdateStatus() {
        dataManager.listenUpdateStatus { [weak self] (receivedDict) -> Void in
            if let strongSelf = self {
                if let canGetStatus = receivedDict["canPullStatus"] as? Bool {
                    if canGetStatus {
                        strongSelf.dataModel = WatchStatusModel.objectFromDict(receivedDict)
                    } else {
                        strongSelf.resetStatus()
                    }
                    strongSelf.updateStatus()
                } else {
                    // why?
                }
            } else {
                // what self denit before? no need to responde
            }
        }
    }
    
    func pullStatus() {
        dataManager.pullStatus({ [weak self] (replyDict) -> Void in
            if let strongSelf = self {
                if let canPullStatus = replyDict["canPullStatus"] as? Bool{
                    if canPullStatus {
                        strongSelf.dataModel = WatchStatusModel.objectFromDict(replyDict)
                    } else {
                        strongSelf.resetStatus()
                    }
                    strongSelf.updateStatus()
                
                } else {
                // why?
                }
            }
            }) { [weak self] (errorDescription) -> Void in
                if let strongSelf = self {
                    strongSelf.delegate?.didOccurErrorWithDescription(errorDescription)
                }
        }
    }
    
    func pushStart() {
        dataManager.pushStart({ [weak self] (replyDict) -> Void in
            print(replyDict)
            if let strongSelf = self {
                if let canPushStart = replyDict["canPushStart"] as? Bool where canPushStart{
                    if replyDict["isTesting"] as! Bool {
                        strongSelf.dataModel = WatchStatusModel.objectFromDict(replyDict)
                        strongSelf.updateStatus()
                    } else {
                        strongSelf.dataModel = WatchStatusModel.objectFromDict(replyDict)
                        strongSelf.updateStatus()
                        strongSelf.delegate?.didOccurErrorWithDescription("无法开始")
                    }
                
                } else {
                    strongSelf.delegate?.didOccurErrorWithDescription("无法开始")
                }
            } else {
                
            }
            }) { [weak self] (errorDescription) -> Void in
                if let strongSelf = self {
                    strongSelf.delegate?.didOccurErrorWithDescription(errorDescription)
                }
        }
    }
    
    func pushStop() {
        dataManager.pushStart({ [weak self] (replyDict) -> Void in
            if let strongSelf = self {
                if let canPushStop = replyDict["canPushStop"] as? Bool where canPushStop{
                    if !(replyDict["isTesting"] as! Bool) {
                        strongSelf.dataModel = WatchStatusModel.objectFromDict(replyDict)
                        strongSelf.updateStatus()
                    } else {
                        strongSelf.dataModel = WatchStatusModel.objectFromDict(replyDict)
                        strongSelf.updateStatus()
                        strongSelf.delegate?.didOccurErrorWithDescription("无法停止")
                    }
                    
                } else {
                    strongSelf.delegate?.didOccurErrorWithDescription("无法停止")
                }
            } else {
                
            }
            }) { [weak self] (errorDescription) -> Void in
                if let strongSelf = self {
                    strongSelf.delegate?.didOccurErrorWithDescription(errorDescription)
                }
        }
    }
    
    func pullRecordContextsWithNumber(number: Int){
        dataManager.pullRecordsWithNumber(number, replyHandler: { [weak self] (reply) -> Void in
            
            if let strongSelf = self {
                print(reply)
                if let canGetRecord = reply["canPullRecord"] as? Bool {
                    if canGetRecord {
                        let number = reply["numberOfRecords"] as! Int
                        if number == 0 {
                            strongSelf.delegate?.didOccurErrorWithDescription("尚无相关记录")
                            return
                        }
                        strongSelf.recordsDataModel = [WatchRecordModel]()
                        let dicts = reply["records"] as! [[String: AnyObject]]
                        for i in 0..<number {
                            let dict = dicts[i]
                            
                            strongSelf.recordsDataModel!.append(WatchRecordModel.objectFromDict(dict)!)
                        }
                        strongSelf.delegate?.didPullRecordContexts()
                    } else {
                            strongSelf.delegate?.didOccurErrorWithDescription("无法读取记录，请检查手机运行状况")
                    }
                } else {
                    // 不会有其他来自手机的响应了
                    NSLog("请求数据失败")
                }
            }
            
            }) { [weak self] (errorDescription) -> Void in
                if let strongSelf = self {
                    strongSelf.delegate?.didOccurErrorWithDescription(errorDescription)
                }
        }
    }
    
    ///  监听新产生的记录
    func listenPushRecord() {
        dataManager.listenMessage("pushRecord") { [weak self] (message) -> Void in
            if let strongSelf = self where strongSelf.dataModel != nil {
                if let object = WatchRecordModel.objectFromDict(message) {
                    strongSelf.receivedUnshownRecord.append(object)
                    // 这里需要讨论
                    if strongSelf.receivedUnshownRecord.count > 4 {
                        strongSelf.receivedUnshownRecord.removeFirst()
                    }
                }
            }
        }
    }
    
    
    /// MARK - private methods
    
    func updateStatus() {
        if let statusModel = self.dataModel {
            self.isValidStatus = true
            self.isTesting = statusModel.isTesting
            self.balanceABatteryString = TNFontIcon.batteryStatus[statusModel.balanceABatteryLevel].rawValue
            self.balanceASignaString = TNFontIcon.signalStatus[statusModel.balanceASignalLevel].rawValue
            self.balanceBBatteryString = TNFontIcon.batteryStatus[statusModel.balanceBBatteryLevel].rawValue
            self.balanceBSignalString = TNFontIcon.signalStatus[statusModel.balanceBSignalLevel].rawValue
            self.instrumentConnectionString = statusModel.isInstrumentConnected ? TNFontIcon.LanConnected.rawValue : TNFontIcon.LanDisConnected.rawValue
            self.automobileStatusString = statusModel.isAutomobileExisted ? "有车" : "无车"
            
        } else {
            self.resetStatus()
        }
        self.delegate?.didUpdateStatusViewModel()
    }
    
    func resetStatus() {
        dataModel = nil
        isValidStatus = false
        isTesting = false
        balanceABatteryString = TNFontIcon.batteryStatus[0].rawValue
        balanceASignaString = TNFontIcon.signalStatus[0].rawValue
        balanceBBatteryString = TNFontIcon.batteryStatus[0].rawValue
        balanceBSignalString = TNFontIcon.signalStatus[0].rawValue
        instrumentConnectionString = TNFontIcon.LanDisConnected.rawValue
        automobileStatusString = "未知"
    }
    
    func setObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deleteRecordHandler:", name: "DeleteRecordNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "printRecordHandler:", name: "PrintRecordNotification", object: nil)
    }
    
    /// MARK - handlers
    
    func deleteRecordHandler(notification: NSNotification) {
        if let deleteSuccess = notification.object!["deleteSuccess"] as? Bool where deleteSuccess {
            let plate = notification.object!["plateString"] as! String
            self.delegate?.didOccurErrorWithDescription("\(plate)的记录\n删除成功")
        } else {
            self.delegate?.didOccurErrorWithDescription("删除记录失败")
        }
    }
    
    func printRecordHandler(notification: NSNotification) {
        if let deleteSuccess = notification.object!["printSuccess"] as? Bool where deleteSuccess {
            let plate = notification.object!["plateString"] as! String
            self.delegate?.didOccurErrorWithDescription("\(plate)的记录\n打印成功")
        } else {
            self.delegate?.didOccurErrorWithDescription("打印记录失败")
        }
    }
    
    func scanReceivedUnshownRecord(timer: NSTimer) {
        if self.alertBlock {
            return
        }
        
        if let record = receivedUnshownRecord.first {
            let description = "\(record.axleTypeString)\n车重\(record.weightString)\n\(record.isOverWeight ? "超重\(record.overWeigthString)": "未超重")"
            let plate = record.plateString
            
            self.delegate?.didReceivedNewRecordWithPlateString(plate, description: description)
            receivedUnshownRecord.removeFirst()
        }
    }
}

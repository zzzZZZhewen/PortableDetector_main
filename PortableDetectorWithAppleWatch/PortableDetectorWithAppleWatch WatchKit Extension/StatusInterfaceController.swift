//
//  InterfaceController.swift
//  WatchForPD WatchKit Extension
//
//  Created by 缪哲文 on 16/1/28.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import WatchKit
import Foundation

/// 入口InterfaceController
class StatusInterfaceController: WKInterfaceController {
    
    var counter = 0
    
    
    let viewModel = StatusViewModel()
    
    @IBOutlet var balanceAIcon: WKInterfaceLabel!
    @IBOutlet var balanceABattery: WKInterfaceLabel!
    @IBOutlet var balanceASignal: WKInterfaceLabel!
    @IBOutlet var balanceBIcon: WKInterfaceLabel!
    @IBOutlet var balanceBBattery: WKInterfaceLabel!
    @IBOutlet var balanceBSignal: WKInterfaceLabel!
    @IBOutlet var instrumentIcon: WKInterfaceLabel!
    @IBOutlet var instrumentConnection: WKInterfaceLabel!
    @IBOutlet var automobileIcon: WKInterfaceLabel!
    @IBOutlet var automobileStatus: WKInterfaceLabel!
    
    /// MARK - life circle
    
    ///  手表醒来，设置初始界面，加载模型
    ///
    ///  - parameter context: 用来更新模型的上下文
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        //初始化vm
        self.viewModel.delegate = self
        //初始化界面
        balanceAIcon.setText(TNFontIcon.BalanceA.rawValue)
        balanceBIcon.setText(TNFontIcon.BalanceB.rawValue)
        instrumentIcon.setText(TNFontIcon.Dashboard.rawValue)
        automobileIcon.setText(TNFontIcon.Automobile.rawValue)
        
        viewModel.getLastStatus()
        //viewModel.pullStatus()
        viewModel.listenUpdateStatus()
        viewModel.listenPushRecord()
    
    }
    
    override func willActivate() {
        super.willActivate()
        // 获取最后一个context 和 继续监听前后文变化
        print("dida")
        viewModel.alertBlock = false
    }
    
    
    override func didDeactivate() {
        print("didd")
        super.didDeactivate()
        viewModel.alertBlock = true
    }
    
    deinit {
        
        print("denit")
    }
    
    /// MARK - event handler
    
    func didMenuStartTapped() {
        viewModel.pushStart()
    }
    
    func didMenuStopTapped() {
        viewModel.pushStop()
    }
    
    func didMenuRecordListTapped() {
        viewModel.pullRecordContextsWithNumber(7)
        
    }
    
    func didMenuRefreshTapped() {
        viewModel.pullStatus()
    }
    
    
    
    /// MARK - private method
    
    func updateStatus() {
        balanceABattery.setText(viewModel.balanceABatteryString)
        balanceASignal.setText(viewModel.balanceASignaString)
        balanceBBattery.setText(viewModel.balanceBBatteryString)
        balanceBSignal.setText(viewModel.balanceBSignalString)
        instrumentConnection.setText(viewModel.instrumentConnectionString)
        automobileStatus.setText(viewModel.automobileStatusString)
        self.clearAllMenuItems()
        if viewModel.isTesting && viewModel.isValidStatus {
            setTitle("正在检测")
            self.addMenuItemWithImage(UIImage.init(named: "icon_stop")!,  title: "停止检测", action: "didMenuStopTapped")
        } else {
            if viewModel.isValidStatus {
                setTitle("未开始检测")
            } else {
                setTitle("未知检测状态")
            }
            
            self.addMenuItemWithImage(UIImage.init(named: "icon_start")!,  title: "开始检测", action: "didMenuStartTapped")
        }
        self.addMenuItemWithImage(UIImage.init(named: "icon_record")!, title: "检测记录", action: "didMenuRecordListTapped")
        self.addMenuItemWithImage(UIImage.init(named: "icon_refresh")!, title: "刷新", action: "didMenuRefreshTapped")
    }
    
}

extension StatusInterfaceController: StatusViewModelDelegate {
    func didUpdateStatusViewModel() {
        self.updateStatus()
    }
    
    func didPullRecordContexts() {
        if let contexts = self.viewModel.recordsDataModel {
            let controllerNames = [String](count: contexts.count, repeatedValue: "RecordInterfaceControllerID")
            presentControllerWithNames(controllerNames, contexts: contexts)
        }
    }
    
    func didOccurErrorWithDescription(description: String) {
        self.presentAlertControllerWithTitle("尊贵的用户您好:", message: "\(description)", preferredStyle: .Alert, actions: [WKAlertAction.init(title: "知道了", style: .Cancel, handler: {() -> Void in
            
        })])
    }
    
    func didReceivedNewRecordWithPlateString(plateString: String, description: String) {
        self.presentAlertControllerWithTitle(plateString, message: description, preferredStyle: .SideBySideButtonsAlert, actions: [WKAlertAction.init(title: "返回", style: .Default, handler: { () -> Void in
            
        }),WKAlertAction.init(title: "查看", style: .Destructive, handler: { [weak self] () -> Void in
            if let strongSelf = self {
                strongSelf.viewModel.pullRecordContextsWithNumber(7)
            }
        })])
    }
}

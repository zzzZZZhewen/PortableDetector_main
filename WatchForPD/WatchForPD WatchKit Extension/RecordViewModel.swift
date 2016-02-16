//
//  RecordViewModel.swift
//  WatchForPD
//
//  Created by 缪哲文 on 16/1/31.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import WatchKit

@objc protocol RecordViewModelDelegate {
    func didUpdateRecordViewModel()
    func didPrintRecord()
    func didDeleteRecord()
    func didOccurErrorWithDescription(description: String)
}

class RecordViewModel: NSObject {
    weak var delegate: RecordViewModelDelegate?
    
    var plateString: String = "未知车牌"
    var axleTypeString: String = "未知轴型"
    var speedString: String = "未知车速"
    var weightString: String = "未知重量"
    var overWeigthAttributedString = NSMutableAttributedString(string: "未知超重")
    var datetimeString: String = "未知日期"
    var isOverWeight = false
    
    var dataModel: WatchRecordModel?
    var dataManager = RecordDataManager()
    
    override init() {
        super.init()
    }
    
    init(model: WatchRecordModel) {
        self.dataModel = model
    }
    
    func showRecord(context: WatchRecordModel) {
        self.dataModel = context
        self.updateRecord()
        self.delegate?.didUpdateRecordViewModel()
    }
    
    /// MARK - private method
    
    func updateRecord() {
        if let recordModel = dataModel {
            self.plateString = recordModel.plateString
            self.axleTypeString = recordModel.axleTypeString
            self.speedString = recordModel.speedString
            self.weightString = recordModel.weightString
            
            self.datetimeString = recordModel.datetimeString
            self.isOverWeight = recordModel.isOverWeight
            
            if self.isOverWeight {
                self.overWeigthAttributedString = NSMutableAttributedString(string: "超重 \(recordModel.overWeigthString)")
                self.overWeigthAttributedString.addAttribute(NSForegroundColorAttributeName,
                    value: UIColor.init(colorLiteralRed: 251/255, green: 15/255, blue: 70/255, alpha: 1.0),
                    range: NSMakeRange(0, overWeigthAttributedString.length))
            } else {
                self.overWeigthAttributedString = NSMutableAttributedString(string: "未超重")
                self.overWeigthAttributedString.addAttribute(NSForegroundColorAttributeName,
                value: UIColor.init(colorLiteralRed: 4/255, green: 222/255, blue: 113/255, alpha: 1.0),
                range: NSMakeRange(0, overWeigthAttributedString.length))
            }
        }
    }
    
    func deleteRecordWithPlateString(plateString: String) {
        //发出删除命令
        self.dataManager.deleteRecordWithPlateString(plateString, replyHandler: { (replyDict) -> Void in
            print(replyDict)
            if let canDeleteRecord = replyDict["canDeleteRecord"] as? Bool where canDeleteRecord{
                NSNotificationCenter.defaultCenter().postNotificationName("DeleteRecordNotification", object: ["deleteSuccess": true, "plateString": plateString])
                
            } else {
                
                NSNotificationCenter.defaultCenter().postNotificationName("DeleteRecordNotification", object: ["deleteSuccess": false, "plateString": plateString])
            }
            }) { (errorDescription) -> Void in
            self.delegate?.didOccurErrorWithDescription(errorDescription)
                
        }
        self.delegate?.didDeleteRecord()
    }
    
    func printRecordWithPlateString(plateString: String) {
        //发出打印命令
        self.dataManager.printRecordWithPlateString(plateString, replyHandler: { (replyDict) -> Void in
            
            if let canPrintRecord = replyDict["canPrintRecord"] as? Bool where canPrintRecord{
                NSNotificationCenter.defaultCenter().postNotificationName("PrintRecordNotification", object: ["printSuccess": true, "plateString": plateString])
                
            } else {
                
                NSNotificationCenter.defaultCenter().postNotificationName("PrintRecordNotification", object: ["printSuccess": false, "plateString": plateString])
            }
            
            }) { (errorDescription) -> Void in
                self.delegate?.didOccurErrorWithDescription(errorDescription)
        }
        self.delegate?.didPrintRecord()
    }
    
}

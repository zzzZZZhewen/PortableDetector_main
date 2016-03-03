//
//  RecordInterfaceController.swift
//  WatchForPD
//
//  Created by 缪哲文 on 16/1/31.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import WatchKit
import Foundation


class RecordInterfaceController: WKInterfaceController {
    
    let viewModel = RecordViewModel()
    
    @IBOutlet var recordIcon: WKInterfaceLabel!
    
    @IBOutlet var plate: WKInterfaceLabel!
    @IBOutlet var axleType: WKInterfaceLabel!
    @IBOutlet var speed: WKInterfaceLabel!
    @IBOutlet var weight: WKInterfaceLabel!
    @IBOutlet var overweight: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.viewModel.delegate = self
        
        recordIcon.setText(TNFontIcon.Automobile.rawValue)
        
        if let dataModel = context as? WatchRecordModel {
            self.viewModel.showRecord(dataModel)
        }
        
    }
    
    /// MARK - event handler
    
    @IBAction func didDeleteButtonTapped() {
        viewModel.deleteRecordWithPlateString(viewModel.plateString)
    }

    @IBAction func didPrintButtonTapped() {
        viewModel.printRecordWithPlateString(viewModel.plateString)
    }
    /// MARK - private method
    
    func updateRecord() {
        plate.setText(self.viewModel.plateString)
        axleType.setText(self.viewModel.axleTypeString)
        speed.setText(self.viewModel.speedString)
        weight.setText(self.viewModel.weightString)
        overweight.setAttributedText(self.viewModel.overWeigthAttributedString)
    }
}

extension RecordInterfaceController: RecordViewModelDelegate {
    func didUpdateRecordViewModel() {
        self.updateRecord()
    }
    func didPrintRecord() {
        self.dismissController()
    }
    func didDeleteRecord() {
        self.dismissController()
    }
    func didOccurErrorWithDescription(description: String) {
        self.presentAlertControllerWithTitle("尊贵的用户您好:", message: "\(description)", preferredStyle: WKAlertControllerStyle.Alert, actions: [WKAlertAction.init(title: "知道了", style: WKAlertActionStyle.Cancel, handler: {[weak self] () -> Void in
            if let strongSelf = self {
            }
        })])
    }
}
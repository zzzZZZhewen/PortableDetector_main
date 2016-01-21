//
//  RecordModel.swift
//  PortableDetector
//
//  Created by 缪哲文 on 16/1/21.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import Foundation


//MARK － 定义代理的 回调函数 表示层对Model类在运行期间需要我们关系的事情进行处理
protocol RecordModelDelegate {
    //
    func didGetPlateString (plate: String)
    
    
}

class RecordModel {
    
    //上层代理
    var delegate: RecordModelDelegate!
    
    // 初始化下层
    var dataDealer = DataDealer()
    
    //properties
    var plateNumber : String!
    var batteryA : String!
    
    
    //提供给上层的服务
    func startReadingFile() {
        //下层的代理是自己
        dataDealer.delegate = self
        //给下层发消息
        dataDealer.reading()
        
        
    }
    
}

// 响应下层事件
extension RecordModel : DataDealerDelegate {
    
    func didGetPlateString(plateString: String) {
        
        if delegate != nil {
            delegate.didGetPlateString(plateString)
            
        }
    }
    
    func didGetBatteryAValue(value: Int) {
        
    }
    
}
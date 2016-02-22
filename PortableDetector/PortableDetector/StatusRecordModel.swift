//
//  RecordModel.swift
//  PortableDetector
//
//  Created by 缪哲文 on 16/1/21.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import Foundation

//MARK － delegate 
//定义代理的 回调函数 表示层对Model类在运行期间需要我们关系的事情进行处理
@objc protocol StatusRecordModelDelegate {
    //获得了所有字符串来更新视图
    func didGetAllString ()
    
}

//MARK: - class
/// 检测页面的业务逻辑，保存最近的一条记录和状态
/// 其属性可以直接给ViewController用
/// 其保存的数据模型（DataModel组下面的Status.swift是从数据源中直接提取的源模型
/// 给数据层可以直接使用，拿来给ViewController层需要业务逻辑模型进行转换）
class StatusRecordModel : NSObject {
    
//MARK - properties
    var plateString : String?
    var batteryA : String?
    //保存数据模型
    //var status = Status()
    //上层代理
    weak var delegate: StatusRecordModelDelegate!
    //下层数据层
    var dataManager = StatusRecordDataManager()
    
//MARK - services
    //提供给上层的服务
    func startReadingFile() {
        //选取要操作的下层
        //var dataDealer = DataDealer()
        //下层的代理是自己
        dataManager.delegate = self
        //给下层发消息调用服务
//        dataManager.readingFile()
    }
    
    
//MARK - getters
    
    
}

//MARK - extension
// 响应下层事件 实现代理
extension StatusRecordModel : StatusRecordDataManagerDelegate {
    
    func didGetPlateString(plateString: String) {
        //存下
        self.plateString = plateString
        //如果所有属性都是最新就做下面这个事情
        if delegate != nil {
            delegate.didGetAllString()
            
        }
    }
}
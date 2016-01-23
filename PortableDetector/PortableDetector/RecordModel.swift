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
protocol RecordModelDelegate {
    //获得了所有字符串来更新视图
    func didGetAllString (model : CoreModel!)
    
}

//MARK - class
//检测页面的业务逻辑，保存最近的一条记录
class RecordModel : CoreModel {
    
//MARK - properties
    var plateString : String?
    var batteryA : String?
    
    //上层代理
    var delegate: RecordModelDelegate!
    //缓存经常用的下层
    var dataDealer = DataDealer()
    
//MARK - services
    //提供给上层的服务
    func startReadingFile() {
        //选取要操作的下层
        //var dataDealer = DataDealer()
        //下层的代理是自己
        dataDealer.delegate = self
        //给下层发消息调用服务
        dataDealer.readingFile()
    }
    
    
//MARK - getters
    
    
}

//MARK - extension
// 响应下层事件 实现代理
extension RecordModel : DataDealerDelegate {
    
    func didGetPlateString(plateString: String) {
        //存下
        self.plateString = plateString
        //如果所有属性都是最新就做下面这个事情
        if delegate != nil {
            delegate.didGetAllString(self)
            
        }
    }
}
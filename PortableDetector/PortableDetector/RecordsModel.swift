//
//  RecordModel.swift
//  PortableDetector
//
//  Created by 缪哲文 on 16/1/23.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import Foundation

//MARK － delegate
protocol RecordsModelDelegate {
    
}

//MARK - class
//查询页面的业务逻辑，保存很多记录for TableView
class RecordsModel  {
    
    //MARK - getters
    //上层代理
    var delegate: RecordsModelDelegate!
 }


//
//  TNiOSHelper.swift
//  PortableDetector
//
//  Created by 缪哲文 on 16/1/21.
//  Copyright © 2016年 缪哲文. All rights reserved.
//
// 这个类用来提供可复用的函数

import Foundation

class TNiOSHelper {
    
//    private static let instance = TNiOSHelper()
//    /// 定义一个类变量，提供全局的访问入口，类变量不能存储数值，但是可以返回数值
//    class var sharedHelper: TNiOSHelper {
//        return instance
//    }
    
    
    class func getDocumentsPath () -> String! {
        //save in documents
        let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        
        //let filePath = (documentsPath! as NSString).stringByAppendingPathComponent("pic.png")
        
        return documentsPath
    }
    
    
}
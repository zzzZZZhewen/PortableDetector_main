//
//  TNFileManager.swift
//  PortableDetector
//
//  Created by brainwang on 16/2/19.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import Foundation
class TNFileManager{
    
    
    class func getDocumentsPath () -> String! {
        //save in documents
        let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        
        //let filePath = (documentsPath! as NSString).stringByAppendingPathComponent("pic.png")
        
        return documentsPath
    }
    
    //获取存放车牌大图小图图片目录
    class func getImagePath()->String! {
        return getDocumentsPath()?.stringByAppendingString("/image/")
    }
    
    class func CreateImageFile()->Bool{
        return false
    }
}
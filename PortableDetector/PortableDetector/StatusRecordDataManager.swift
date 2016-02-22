//
//  DocumentManager.swift
//  PortableDetector
//
//  Created by 缪哲文 on 16/1/21.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import Foundation

//MARK - delegate
@objc protocol StatusRecordDataManagerDelegate {
    
    func didGetPlateString(plateString: String)
    
}

/// 专门用来给StatusRecordModel的用例实现数据层操作的类
/// 主要目标是让逻辑层不关心数据是怎么来 怎么去的
class StatusRecordDataManager {
    
//MARK - properties
    weak var delegate : StatusRecordDataManagerDelegate!
    
    
//MARK - services
//    func readingFile() {
//    
//        // case 开始拍照
//        // dispatch
//            // 
//        let picName = TNiOSHelper.getDocumentsPath().stringByAppendingString("pic.png")
//        
//        CameraManager.sharedManager.addDidShootCompletedHandeler { (result, error) -> () in
//            let answer = result as! Bool
//            //拍照成功
//            if answer {
//                PlateManager.sharedManager.analyseWithName(picName)
//            }
//        }
//        
//        PlateManager.sharedManager.addDidAnalyseCompletedHandeler { (result, error) -> () in
//            //得到车牌字符串
//            let plateString = result as! String
//            self.delegate.didGetPlateString(plateString)
//        }
//        
//        CameraManager.sharedManager.shootWithName(picName)
//            //
//        // end dispatch
//        // end case
//    }
//    
////MARK - getters
//    
}
//
//  DocumentManager.swift
//  PortableDetector
//
//  Created by 缪哲文 on 16/1/21.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import Foundation

//MARK - delegate
protocol DataDealerDelegate {
    
    func didGetPlateString(plateString: String)
    
}

//MARK - class
class DataDealer {
    
//MARK - properties
    var delegate : DataDealerDelegate!
    
    
//MARK - services
    func readingFile() {
    
        // case 开始拍照
        // dispatch
            // 
        let picName = TNiOSHelper.getDocumentsPath().stringByAppendingString("pic.png")
        
        
        
        CameraManager.sharedManager.addDidShootCompletedHandeler { (result, error) -> () in
            let answer = result as! Bool
            //拍照成功
            if answer {
                PlateManager.sharedManager.analyseWithName(picName)
            }
        }
        
        PlateManager.sharedManager.addDidAnalyseCompletedHandeler { (result, error) -> () in
            //得到车牌字符串
            let plateString = result as! String
            self.delegate.didGetPlateString(plateString)
        }
        
        CameraManager.sharedManager.shootWithName(picName)
            //
        // end dispatch
        // end case
    }
    
//MARK - getters
    
}
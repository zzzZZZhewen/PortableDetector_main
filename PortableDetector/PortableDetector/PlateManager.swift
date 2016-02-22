//
//  PlateManager.swift
//  PortableDetector
//
//  Created by 缪哲文 on 16/1/21.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import Foundation

class PlateManager {
//MARK - 单例模式
    private static let instance = PlateManager()
    
    class var sharedManager: PlateManager {
        return instance
    }
    
//MARK - property
    
//MARK - services
    func analyseWithName(picName:String) {
        //
        //
        //告诉调用者，事情已经办完了
//        self.didAnalyseCompletedHandeler(result: nil, error: nil)
    }
    
    
    //MARK - handler
//    var didAnalyseCompletedHandeler : ManagerMissionCompletedCloureWithResultError = {(result : AnyObject?, error : ErrorType?) -> () in return}
//    
//    // set handler
//    func addDidAnalyseCompletedHandeler (handler : ManagerMissionCompletedCloureWithResultError!) {
//        self.didAnalyseCompletedHandeler = handler
//    }
    
}
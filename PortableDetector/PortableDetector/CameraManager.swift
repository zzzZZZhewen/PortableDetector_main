//
//  CameraManager.swift
//  PortableDetector
//
//  Created by 缪哲文 on 16/1/21.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import Foundation
import AVFoundation

//MARK - class
class CameraManager {
//MARK - 单例模式
    private static let instance = CameraManager()
    
    class var sharedManager: CameraManager {
        return instance
    }
    
//MARK - property
    
//MARK - services
    func shootWithName(picName:String) {
        //
        //
        //告诉调用者，事情已经办完了
//        self.didShootCompletedHandeler(result: true, error: nil)
    }
    
//MARK - handler
//    var didShootCompletedHandeler : ManagerMissionCompletedCloureWithResultError = {(result : AnyObject?, error : ErrorType?) -> () in return}
//    
//    // set handler
//    func addDidShootCompletedHandeler (handler : ManagerMissionCompletedCloureWithResultError!) {
//        self.didShootCompletedHandeler = handler
//    }
//
//    
}
//
//  CameraManager.swift
//  PortableDetector
//
//  Created by 缪哲文 on 16/1/21.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import Foundation
import AVFoundation

class CameraManager {
    // 单例模式
    private static let instance = CameraManager()
    /// 定义一个类变量，提供全局的访问入口，类变量不能存储数值，但是可以返回数值
    class var sharedManager: CameraManager {
        return instance
    }
    
    //MARK - property
    var previewLayer: AVCaptureVideoPreviewLayer!
    var captureSession : AVCaptureSession!
    var metadataOutput: AVCaptureMetadataOutput!
    var videoDevice:AVCaptureDevice!
    var videoInput: AVCaptureDeviceInput!
    var running = false
    
    
    func shoot(picName:String , completion: (result: AnyObject?, error: NSError?) -> ()) {
        // paizhaowanbi
        
        completion(result: nil,error: nil)
    }
    
    
}
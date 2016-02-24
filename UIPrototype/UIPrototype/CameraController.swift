//
//  CameraView.swift
//  UIPrototype
//
//  Created by 缪哲文 on 16/2/22.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraControllerDelegate : class {
    func cameraController(cameraController: CameraController, didShootSucceededWithImageData imageData: NSData)
}

protocol CameraControllerProtocol {
    var cameraController:CameraController! { get set }
}

class CameraController: NSObject {
    weak var delegate: CameraControllerDelegate?

    var captureDevice:  AVCaptureDevice? // represent the input device, such as a camera or microphone
    var captureDeviceInput: AVCaptureDeviceInput? // to configure the ports from the input device
    //var aVCaptureOutput: AVCaptureOutput? // to manage the output to a movie file or still image
    var stillImageOutput: AVCaptureStillImageOutput?
    
    var captureSession: AVCaptureSession? // to coordinate the data flow from the input to the output
    var videoPreviewLayer: AVCaptureVideoPreviewLayer? // (a subclass of CALayer). To show the user a preview of what the camera is recording
    
    init(delegate:CameraControllerDelegate?) {
        super.init()
        self.delegate = delegate
        
        let authorizationStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        
        switch authorizationStatus {
        case .NotDetermined:
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo,
                completionHandler: { (granted:Bool) -> Void in
                    if granted {
                        
                        self.setupCaptureSession()
                        self.startCaptureSession()
                    }
                    else {
                        print("权限有问题")
                    }
            })
        case .Authorized:
            
            self.setupCaptureSession()
            self.startCaptureSession()
        case .Denied, .Restricted:
            print("权限有问题")
            break
        }

    }
    
    // MARK: - public
    func setupCaptureSession() {
        //1 创建会话
        self.captureSession = AVCaptureSession()
        self.captureSession?.sessionPreset = AVCaptureSessionPresetPhoto
        //sessionPreset属性用于控制会话的数据质量，在拍摄视频时比较有用，这里我们只需要设为AVCaptureSessionPresetPhoto就可以了
        
        //2 创建输入设备
        self.captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        //3 创建输入
        self.captureDeviceInput = try?AVCaptureDeviceInput(device: self.captureDevice)
        //4 创建输出
        self.stillImageOutput = AVCaptureStillImageOutput()
        self.stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        //5 连接输入输出与会话
        if let session = self.captureSession {
            if session.canAddInput(self.captureDeviceInput) {
                session.addInput(self.captureDeviceInput)
            }
            if session.canAddOutput(self.stillImageOutput) {
                session.addOutput(self.stillImageOutput)
            }
            
            //6 预览
            self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.currentDevice().orientation.rawValue)!
        }
        
    }
    
    func startCaptureSession() {
        self.captureSession?.startRunning()
    }
    
    func stopCaptureSession() {
        self.captureSession?.stopRunning()
    }
    
    func shoot() {
        // 1.获得连接
        let captureConnection = self.stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo)
        // 控制拍照出来的方向
        captureConnection!.videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.currentDevice().orientation.rawValue)!
        // 2.拍摄照片
        self.stillImageOutput?.captureStillImageAsynchronouslyFromConnection(captureConnection, completionHandler: { (imageDataBuffer, error) -> Void in
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
            
            //通知拍摄完毕
            self.delegate?.cameraController(self, didShootSucceededWithImageData: imageData)
            
            // 保存到相册
            //if let image = UIImage(data: imageData) {
            //    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            //}
        })
       
    }
    
    // MARK: - private

}



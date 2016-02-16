//
//  ViewController.swift
//  CustomCamera
//
//  Created by 缪哲文 on 16/2/9.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    
    @IBOutlet weak var preview: UIView!
    
    @IBOutlet weak var overlay: UIView!
    
    var  captureDevice:  AVCaptureDevice? // represent the input device, such as a camera or microphone
    var captureDeviceInput: AVCaptureDeviceInput? // to configure the ports from the input device
    //var aVCaptureOutput: AVCaptureOutput? // to manage the output to a movie file or still image
    var stillImageOutput: AVCaptureStillImageOutput?
    
    var captureSession: AVCaptureSession? // to coordinate the data flow from the input to the output
    var videoPreviewLayer: AVCaptureVideoPreviewLayer? // (a subclass of CALayer). To show the user a preview of what the camera is recording
    
    var lastPinchDistance: CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupCaptureSession()
        self.startCaptureSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    @IBAction func captureButtonTapped(sender: AnyObject) {
        // 1.获得连接
        let captureConnection = self.stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo)
        // 2.拍摄照片
        self.stillImageOutput?.captureStillImageAsynchronouslyFromConnection(captureConnection, completionHandler: { (imageDataBuffer, error) -> Void in
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
            if let image = UIImage(data: imageData) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            
        })
    }
    
    @IBAction func flashButtonTapped(sender: AnyObject) {
        self.switchFlashMode()
    }
    
    @IBAction func pinchGestureRecognizer(sender: UIPinchGestureRecognizer) {
        if sender.numberOfTouches() != 2 {
            return
        }
        
        let point0 = sender.locationOfTouch(0, inView: self.overlay)
        let point1 = sender.locationOfTouch(1, inView: self.overlay)
        let distanceX = point0.x - point1.x
        let distanceY = point0.y - point1.y
        let distance = sqrt(distanceX * distanceX + distanceY * distanceY)
        
        if sender.state == UIGestureRecognizerState.Began {
            lastPinchDistance = distance
        }
        
        let change = (distance - self.lastPinchDistance) / CGRectGetWidth(self.view.bounds)
        
        zoomCamera(change)
        
        lastPinchDistance = distance
        
    }
///  设置会话
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
            //其实更好的实现是自定义一个View并在layerClass方法中返回AVCaptureVideoPreviewLayer类型
            self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            setPreviewOrientationWithToInterfaceOrientation(UIApplication.sharedApplication().statusBarOrientation)
            
            
            self.videoPreviewLayer?.frame = self.preview.bounds
            
            self.videoPreviewLayer?.videoGravity = AVLayerVideoGravityResize
            if let layer = videoPreviewLayer {
                
                self.preview.layer.addSublayer(layer)

            }
        }
        
    }
    
    func startCaptureSession() {
        self.captureSession?.startRunning()
    }
    
    func stopCaptureSession() {
        self.captureSession?.stopRunning()
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        
        setPreviewOrientationWithToInterfaceOrientation(toInterfaceOrientation)
        
    }
    
    func setPreviewOrientationWithToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation) {
        
        switch toInterfaceOrientation {
        case .LandscapeLeft:
            self.videoPreviewLayer?.connection.videoOrientation = .LandscapeLeft
            break
        case .LandscapeRight:
            self.videoPreviewLayer?.connection.videoOrientation = .LandscapeRight
            break
        case .Portrait:
            self.videoPreviewLayer?.connection.videoOrientation = .Portrait
            break
        case .PortraitUpsideDown:
            self.videoPreviewLayer?.connection.videoOrientation = .PortraitUpsideDown
            break
        default:
            break
        }
    }
    
    func setPreviewOrientationWithDeviceOrientation(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .LandscapeLeft:
            self.videoPreviewLayer?.connection.videoOrientation = .LandscapeLeft
            break
        case .LandscapeRight:
            self.videoPreviewLayer?.connection.videoOrientation = .LandscapeRight
            break
        case .Portrait:
            self.videoPreviewLayer?.connection.videoOrientation = .Portrait
            break
        case .PortraitUpsideDown:
            self.videoPreviewLayer?.connection.videoOrientation = .PortraitUpsideDown
            break
        case .Unknown:
            /// 默认的朝向 很难呀，因为刚启动是这个值
            break
        default:
            break
        
        }
    }
    
    func switchFlashMode() {
        if let device = self.captureDevice {
            if device.flashActive {
                setFlashMode(AVCaptureFlashMode.Off)
            } else {
                setFlashMode(AVCaptureFlashMode.On)
            }
        }
    }
    
    func setFlashMode(mode: AVCaptureFlashMode) {
        if self.captureDevice!.isFlashModeSupported(mode) {
            if let _ = try?self.captureDevice?.lockForConfiguration() {
                self.captureDevice?.flashMode = mode
                self.captureDevice?.unlockForConfiguration()
            }
        }
    }
    
    func zoomCamera(change: CGFloat) {
        
        if let device = self.captureDevice {
            if let _  = try?device.lockForConfiguration() {
                let factor = device.videoZoomFactor
                let scale = min(max(factor + change * 1.5, 1.0), device.activeFormat.videoMaxZoomFactor)
                device.videoZoomFactor = scale
                print(scale)
                device.unlockForConfiguration()
            }
        }
    }
}


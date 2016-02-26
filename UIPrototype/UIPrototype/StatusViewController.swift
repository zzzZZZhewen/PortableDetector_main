//
//  StatusViewController.swift
//  UIPrototype
//
//  Created by 缪哲文 on 16/2/21.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit
import AVFoundation

class StatusViewController: UIViewController {
    
    @IBOutlet weak var balanceAIcon: UIImageView!
    @IBOutlet weak var balanceBIcon: UIImageView!
    @IBOutlet weak var instrumentIcon: UIImageView!
    @IBOutlet weak var automobileIcon: UIImageView!
    @IBOutlet weak var cameraPreview: UIView!

    @IBOutlet weak var plateTextField: UITextField!
    
    ///add by wby
    
    @IBOutlet weak var labelCarStatusValue: UILabel!
    @IBOutlet weak var labelCarStatusTitle: UILabel!
    @IBOutlet weak var labelInstrumentStatusValue: UILabel!
    @IBOutlet weak var labelInstrumentStatusTitle: UILabel!
    
    @IBOutlet weak var labelSignalB: UILabel!
    @IBOutlet weak var labelBatteryB: UILabel!
    @IBOutlet weak var labelSignalA: UILabel!
    @IBOutlet weak var labelBatteryA: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var btnPrint: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnDetect: UIButton!
    
    @IBOutlet weak var textOverWeight: UITextField!
    @IBOutlet weak var switchOverWeight: UISwitch!
    @IBOutlet weak var textWeight: UITextField!
    @IBOutlet weak var textSpeed: UITextField!
    @IBOutlet weak var textPlateNumber: UITextField!
    
    @IBOutlet weak var imageViewSmallPlate: UIImageView!
    
    var deviceDataModel:DeviceStatusDataModel!
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    
    enum btnStatusList:Int{
        case Default=0,Detecting,Analyzing,AutoSaving,Saved,Printing
        var btnStatus:[[AnyObject]]{
            switch self{
            case .Default:
                
                return [
                    [true,"开始"],[false,"停止"],[false,"取消"],[false,"保存"],[false,"打印"]
                ]
            case .Detecting:
                return [
                    [false,"检测中"],[true,"停止"],[true,"取消"],[false,"保存"],[false,"打印"]
                ]
            case .Analyzing:
                return [
                    [false,"分析中"],[false,"停止"],[true,"取消"],[false,"保存"],[false,"打印"]
                ]
            case .AutoSaving:
                return [
                    [true,"开始"],[false,"停止"],[true,"取消"],[true,"保存(5)"],[false,"打印"]
                ]
            case .Saved:
                return [
                    [true,"开始"],[false,"停止"],[true,"取消"],[false,"保存"],[true,"打印"]
                ]
            case .Printing:
                return [
                    [true,"开始"],[false,"停止"],[false,"取消"],[false,"保存"],[false,"打印中"]
                ]
                
            }
        }
        
        
    }
    //set a single button status
    private func setButtonStatus(button:UIButton,status:[AnyObject]){
        button.enabled=(status[0] as! Bool)
        button.setTitle(status[1] as? String, forState:UIControlState.Normal)
        
        
        
    }
    
    //设置所有按钮状态
    private func setAllBtnStatus(btnStatusList:[[AnyObject]]){
        setButtonStatus(btnDetect, status: btnStatusList[0])
        setButtonStatus(btnStop, status: btnStatusList[1])
        setButtonStatus(btnCancel, status: btnStatusList[2])
        setButtonStatus(btnSave, status: btnStatusList[3])
        setButtonStatus(btnPrint, status: btnStatusList[4])
        
    }
    //当前检测状态
    var currentDetectStatus=btnStatusList.Default{
        
        willSet{
            setAllBtnStatus(newValue.btnStatus)
        }
    }
    //注册按钮事件
    private func registerButtonListener(){
        
        btnDetect.addTarget(self, action: Selector("btnDetectOnclick"), forControlEvents: .TouchUpInside)
        btnStop.addTarget(self, action: Selector("btnStopOnclick"), forControlEvents: .TouchUpInside)
        btnCancel.addTarget(self, action: Selector("btnCancelOnclick"), forControlEvents: .TouchUpInside)
        btnSave.addTarget(self, action: Selector("btnSaveOnclick"), forControlEvents: .TouchUpInside)
        btnPrint.addTarget(self, action: Selector("btnPrintOnclick"), forControlEvents: .TouchUpInside)
        
        
    }
    
    
    func btnDetectOnclick(){
        deviceDataModel.startDetect()
    }
    func btnStopOnclick(){
        deviceDataModel.stopDetect()
        
    }
    func btnCancelOnclick(){
        print("取消操作")
        deviceDataModel.cancelDetect()
    }
    func btnSaveOnclick(){
        deviceDataModel.saveRecord()
    }
    func btnPrintOnclick(){
        //  deviceDataModel.Print()
    }
    
    
    
    //更新设备状态
    func loadDeviceStatus(deviceStatusDatatModel:DeviceStatusDataModel){
        dispatch_sync(dispatch_get_main_queue(), {
            self.currentDetectStatus=deviceStatusDatatModel.detectStatus
            
            self.labelCarStatusValue.text=deviceStatusDatatModel.labelCarStatusValue
            self.labelCarStatusTitle.text=deviceStatusDatatModel.labelCarStatusTitle
            self.labelInstrumentStatusValue.text=deviceStatusDatatModel.labelInstrumentStatusValue
            self.labelInstrumentStatusTitle.text=deviceStatusDatatModel.labelInstrumentStatusTitle
            
            self.labelSignalB.text=deviceStatusDatatModel.labelSignalB
            self.labelBatteryB.text=deviceStatusDatatModel.labelBatteryB
            self.labelSignalA.text=deviceStatusDatatModel.labelSignalA
            self.labelBatteryA.text=deviceStatusDatatModel.labelBatteryA
            
            
        })
        
    }
    
    //更新检测记录情况
    func loadDetectRecord(deviceStatusDatatModel:DeviceStatusDataModel){
        dispatch_sync(dispatch_get_main_queue(), {
            //self.imageViewSmallPlate.
            self.imageViewSmallPlate.image=deviceStatusDatatModel.plateImage
            
            self.textSpeed.text=deviceStatusDatatModel.textSpeed
            self.textWeight.text=deviceStatusDatatModel.textWeight
            self.textPlateNumber.text=deviceStatusDatatModel.textPlateNumber
            
            
            self.textSpeed.enabled=deviceStatusDatatModel.recordEditEnable
            self.textWeight.enabled=deviceStatusDatatModel.recordEditEnable
            self.textPlateNumber.enabled=deviceStatusDatatModel.recordEditEnable
            
        })
        
    }
    
    
    
    ///add by wby end
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setIcons()
        ///add by wby
        
        //deviceStatusDatatModel.isBalanceAConnected
        registerButtonListener()
        
        deviceDataModel = DeviceStatusDataModel(delegate: self)
        ///add by wby end
        deviceDataModel.startSocket()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let previewLayer = cameraPreviewLayer {
            previewLayer.frame = cameraPreview.bounds
            previewLayer.connection.videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.currentDevice().orientation.rawValue)!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - event
    

    
    // MARK: - private
    
    func setIcons() {
        self.balanceAIcon.tintColor = UIColor(red: 236/255, green: 63/255, blue: 140/255, alpha: 1.0)
        self.balanceBIcon.tintColor = UIColor(red: 236/255, green: 63/255, blue: 140/255, alpha: 1.0)
        self.instrumentIcon.tintColor = UIColor(red: 57/255, green: 177/255, blue: 198/255, alpha: 1.0)
        self.automobileIcon.tintColor = UIColor(red: 57/255, green: 177/255, blue: 198/255, alpha: 1.0)
    }
    
}

//add by wby
extension StatusViewController: DeviceStatusDelegate {
    func statusDataModel(didGetStautsWithDataModel dataModel: DeviceStatusDataModel){
        loadDeviceStatus(dataModel)//加载下层计算后的数据模型显示界面
    }
    
    func detectDataModel(didGetStautsWithDataModel dataModel: DeviceStatusDataModel){
        loadDetectRecord(dataModel)//加载下层计算后的数据模型显示界面
    }
    func cameraControllerDidInitiated(cameraController: CameraController) {
        if let previewLayer = cameraController.videoPreviewLayer {
            previewLayer.frame = cameraPreview.bounds
            cameraPreview.layer.addSublayer(previewLayer)
            cameraPreviewLayer = previewLayer
        }
    }
}

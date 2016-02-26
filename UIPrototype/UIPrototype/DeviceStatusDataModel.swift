//
//  DeviceStatusDataModel.swift
//  UIPrototype
//
//  Created by brainwang on 16/2/23.
//  Copyright © 2016年 缪哲文. All rights reserved.
//
import UIKit
import Foundation
protocol DeviceStatusDelegate: class {
    func statusDataModel(didGetStautsWithDataModel dataModel: DeviceStatusDataModel)
    func detectDataModel(didGetStautsWithDataModel dataModel: DeviceStatusDataModel)
    func cameraControllerDidInitiated(cameraController: CameraController)
}


//上面的信息状态栏。电量，信号等
class DeviceStatusDataModel {
    weak var delegate:DeviceStatusDelegate!
        var isBalanceAConnected = false{
        didSet{
            if(!isBalanceAConnected){
                
                labelSignalA="信号:－－"
                labelBatteryA="电量:－％"
            }
        }
    }
    var  isBalanceBConnected = false{
        didSet{
            if(!isBalanceBConnected){
                
                labelSignalB="信号:－－"
                labelBatteryB="电量:－％"
            }
        }
    }
    private var isInstrumentConnected = false{
        didSet{
            if(!isInstrumentConnected){//如果仪表断掉，全部初始化
                
                labelCarStatusValue="未知"
                labelCarStatusTitle="状态"
                
                labelInstrumentStatusValue="未连接"
                labelInstrumentStatusTitle="状态"
                
                
                isBalanceAConnected=false
                isBalanceBConnected=false
                
                labelSignalA="信号:－－"
                labelBatteryA="电量:－％"
            }else{
                labelInstrumentStatusValue="已连接"
                labelInstrumentStatusTitle="状态"

            }
        }
    }
    
    
    private var balanceABatteryLevel = 0{
        didSet{
            labelBatteryA="电量:\(balanceABatteryLevel)%"
            
        }
    }
    private var balanceBBatteryLevel = 0{
        didSet{
            labelBatteryB="电量:\(balanceBBatteryLevel)%"

        }
    }
    private var instrumentBatteryLevel = 0{
        didSet{
            labelInstrumentStatusValue="\(instrumentBatteryLevel)%"
            labelInstrumentStatusTitle="电量"
        }
    }
    
    
    private var balanceASignalLevel = 16{
        didSet{
            switch balanceASignalLevel{
            case 0:
                labelSignalA="信号:强"
            case 1:
                labelSignalA="信号:一般"
            case 2:
                labelSignalA="信号:弱"
            default:
                print("")
                
            }
        }
        
    }
    private var balanceBSignalLevel = 16{
        didSet{
            switch balanceBSignalLevel{
            case 0:
                labelSignalB="信号:强"
            case 1:
                labelSignalB="信号:一般"
            case 2:
                labelSignalB="信号:弱"

            default:
                print("")
                
            }
        }
    }
    
    private var hasCar=false{
        willSet{
            if(hasCar==false && newValue==true){
                print("开始检测")
                startDetect()
               
            }else if hasCar==true && newValue==false{
                print("停止检测")
                stopDetect()
                
            }
        }
        didSet{
            labelCarStatusValue=(hasCar ? "有车" : "无车")
                print("\(labelCarStatusValue)")
            }
       
    }

    var detectStatus=StatusViewController.btnStatusList.Default{
        didSet{
            switch(detectStatus){
                
            case StatusViewController.btnStatusList.Detecting:
                //startDetect()
                print("检测中")
                recordEditEnable=false
            case StatusViewController.btnStatusList.Analyzing:
                //stopDetect()
                print("分析中")
                recordEditEnable=false
            case  StatusViewController.btnStatusList.AutoSaving:
                recordEditEnable=true
                print("自动保存中")
            case  StatusViewController.btnStatusList.Saved:
                recordEditEnable=false
                print("保存完毕")
                //
            default:
                recordEditEnable=false
            }
            self.delegate?.statusDataModel(didGetStautsWithDataModel: self) //通知上层更新
            self.delegate?.detectDataModel(didGetStautsWithDataModel: self) //通知上层更新
        }
        
    }
    ///存储属性
    
    var labelCarStatusValue="未知"
    var labelCarStatusTitle="状态"
    
    var labelInstrumentStatusValue="未连接"
    var labelInstrumentStatusTitle="状态"
    
    var labelSignalB="信号:－－"
    var labelBatteryB="电量:-%"
    
    var labelSignalA="信号:－－"
    var labelBatteryA="电量:－％"
    
  //  var currentRecord:DetectRecord //最后应该是用这个变量记录当前检测值
    
    var plateImage:UIImage = UIImage(named: "no_plate")!
    var textOverWeight=""
    var switchOverWeight=false
    var textWeight=""
    var textSpeed=""
    var textPlateNumber=""
    
    var recordEditEnable:Bool=false
    
    var socket:TNClientSocket!
    
    var cameraController: CameraController!
    var recognizer: RecognizePlate!
    
    init(delegate:DeviceStatusDelegate){
        self.delegate=delegate
        socket=TNClientSocket(delegate: self)
        cameraController = CameraController(delegate: self)
        self.delegate.cameraControllerDidInitiated(cameraController)
        recognizer = RecognizePlate(delegate: self)
    }
    
    private func loadStatus(cmd:Int,deviceID:Int,value:String){
        print("\(cmd) \(deviceID) \(value)")
        switch cmd{
        case 0://车辆信息
            switch deviceID{
               case 3://称台下发的车辆信息：cmd:0,3,2/2.56/2
                let array2=value.componentsSeparatedByString("/")
                 textOverWeight=""
                 switchOverWeight=false
                 textSpeed=array2[1]
                textWeight=array2[2]
                 //textPlateNumber=""
                detectStatus=StatusViewController.btnStatusList.AutoSaving//数据获取完进入保存阶段
                
            default:
                print("")
            }
            
            
        case 3://有车无车
            switch(value){
            case "start":
                hasCar=true
                
            case "ready":
                hasCar=false
               

            default:
                print("")
                
            }
        case 4://电量
            switch deviceID{
            case 1://A
                balanceABatteryLevel=(value as NSString).integerValue
            case 2://B
                balanceBBatteryLevel=(value as NSString).integerValue
            case 0://仪表
                instrumentBatteryLevel=(value as NSString).integerValue
            default:
                print("")
            }
        case 5://
            switch deviceID{
            case 1:
                balanceASignalLevel=(value as NSString).integerValue
                switch value{
                case "16":
                    isBalanceAConnected=false
                case "0","1","2":
                    isBalanceAConnected=true
                default:
                    print("")
                    
                }
            case 2:
                balanceBSignalLevel=(value as NSString).integerValue
                switch value{
                case "16":
                    isBalanceBConnected=false
                case "0","1","2":
                    isBalanceBConnected=true
                default:
                    print("")
                }
            default:
                print("")
                
            }
        default:
            print("")
        }

    }
    
    func startSocket(){
       
        socket.startRead()
        
    }
    func startDetect(){
      
        socket.send("cmd:2--",dowork:{
            self.detectStatus=StatusViewController.btnStatusList.Detecting
            }
        )
        
        self.cameraController.shoot()
        
    }
    
    func stopDetect(){
        
       
        socket.send("cmd:3--",dowork: {
            
        })//通知称台下发数据

    }
    
    func saveRecord(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),{
            
            self.detectStatus=StatusViewController.btnStatusList.Saved//数据获取完进入保存阶段
            
        })
    }
    
    func cancelDetect(){
        socket.send("cmd:5--", dowork:{
             self.detectStatus=StatusViewController.btnStatusList.Default//数据获取完进入保存阶段
            }
        )
        }
    }

extension DeviceStatusDataModel:TNClientSocketMsgDelegate{
    func updateFromSocket(content:Dictionary<String,AnyObject>){
        if let code=content["success"]{
            let success=code as! Bool
            if success{
               
                let cmd=(content["cmd"] as! NSString).integerValue
                let deviceID=content["deviceID"] as! Int
                let value=content["value"] as! String
                
                loadStatus(cmd, deviceID: deviceID, value: value)
                
            }
        }
        
        self.delegate?.statusDataModel(didGetStautsWithDataModel: self) //通知上层更新
    }
}


extension DeviceStatusDataModel: CameraControllerDelegate {
    func cameraController(cameraController: CameraController, didShootSucceededWithImageData imageData: NSData) {
        
        let queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_async(queue) { [weak self]() -> Void in
            
            
            if let elf = self {
                let path = TNiOSHelper.getDocumentsPath().stringByAppendingString("/t.jpg")
                print(path)
                imageData.writeToFile(path, atomically: false)
                elf.recognizer?.recognizePlate(path)
            }
            
            ///
            //显示车牌号,获取、显示小图，设置小图点击链接
            //self.plateImage=UIImage(data: smallImgData)
            //self.plateImage.accessibilityHint=""//通过这个访问大图路径
        
            
        }
    }
}

extension DeviceStatusDataModel: RecognizePlateDelegate {
    func didFinishRecognizePlate(recognizeResult:IdentifyResult) {
        
        let queue = dispatch_get_main_queue()
        dispatch_async(queue) { [weak self]() -> Void in
            if let elf = self {
                if recognizeResult.getError() == "Success" {
                    
                    elf.textPlateNumber = recognizeResult.getString()
                    elf.plateImage = UIImage(data: recognizeResult.getImage())!
                } else {
                    elf.textPlateNumber =  "识别有误"
                }
            }
        }
    }
}


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
    func readDataModel(didGetStautsWithDataModel dataModel: DeviceStatusDataModel)
    
    func cameraControllerDidInitiated(cameraController: CameraController)
}



//上面的信息状态栏。电量，信号等
class DeviceStatusDataModel {
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
    
    var detectStatus = btnStatusList.Default{
        didSet{
            switch(detectStatus){
                
            case btnStatusList.Detecting:
                //startDetect()
                print("检测中")
                
                recordEditEnable=false
            case btnStatusList.Analyzing:
                //stopDetect()
                print("分析中")
                recordEditEnable=false
            case btnStatusList.AutoSaving:
                
                recordEditEnable=true
                print("自动保存中")
            case btnStatusList.Saved:
                
                recordEditEnable=false
                print("保存完毕")
                //
            default:
                recordEditEnable=false
            }
            self.delegate?.statusDataModel(didGetStautsWithDataModel: self) //通知上层更新
            self.delegate?.detectDataModel(didGetStautsWithDataModel: self) //通知上层更新
            
            // watch
            var context = self.toDictForWatch()
            context["canPullStatus"] = true
            sessionManager.updateApplicationContext(context)
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
    
    var recordEditEnable:Bool=false
    
    var socket:TNClientSocket!
    
    var cameraController: CameraController!
    var recognizer: RecognizePlate!
    
    var currentRecord:DetectedRecord!
    
    
    weak var delegate:DeviceStatusDelegate!
    let sessionManager = WatchSessionManager.sharedManager
    
    init(delegate:DeviceStatusDelegate){
        self.delegate = delegate
        
        socket = TNClientSocket(delegate: self)
        
        
        // watch
        sessionManager.setDidReceiveMessageHandlerForCommand("pullStatus") {(message, replyHandler) -> Void in
            var reply = self.toDictForWatch()
            reply["canPullStatus"] = true
            replyHandler(reply)
        }
            

        /// 这里需要提供一个判断是否成功开始和结束的途径
        sessionManager.setDidReceiveMessageHandlerForCommand("pushStart") {(message, replyHandler) -> Void in
            
            // 在这里设置开始 然后回传状态
            if self.detectStatus == .Default{
                print("start")
                self.startDetect()
            }
            var dict = self.toDictForWatch()
            dict["canPushStart"] = true
            replyHandler(dict)
        }
        sessionManager.setDidReceiveMessageHandlerForCommand("pushStop") {(message, replyHandler) -> Void in
            // 在这里设置停止 然后回传状态
            
            
            
            if self.detectStatus != .Default{
                print("stop")
                self.stopDetect()
            }
            var dict = self.toDictForWatch()
            dict["canPushStop"] = true
            replyHandler(dict)
        }
    }
    
    func toDictForWatch() ->[String: AnyObject] {
        var aSignalLevel = 0
        if balanceASignalLevel == 0 {
            aSignalLevel = 3
        } else if balanceASignalLevel == 1 {
            aSignalLevel = 2
        } else if balanceASignalLevel == 2 {
            aSignalLevel = 1
        }
        var bSignalLevel = 0
        if balanceBSignalLevel == 0 {
            bSignalLevel = 3
        } else if balanceBSignalLevel == 1 {
            bSignalLevel = 2
        } else if balanceBSignalLevel == 2 {
            bSignalLevel = 1
        }
        
        var aBatteryLevel = balanceABatteryLevel / 25
        if aBatteryLevel == 4 {
            aBatteryLevel = 3
        }
        
        var bBatteryLevel = balanceBBatteryLevel / 25
        if bBatteryLevel == 4 {
            bBatteryLevel = 3
        }
        
        let dict: [String : AnyObject] = [
            "isTesting": detectStatus == .Default ? false : true,
            "balanceABatteryLevel": aBatteryLevel,
            "balanceBBatteryLevel": bBatteryLevel,
            "balanceASignalLevel": aSignalLevel,
            "balanceBSignalLevel": bSignalLevel,
            "isInstrumentConnected": isInstrumentConnected,
            "isAutomobileExisted": hasCar]
        
        return dict
    }

    // serivce
    func startCamera() {
        if cameraController != nil {
            return 
        }
        cameraController = CameraController(delegate: self)
        delegate.cameraControllerDidInitiated(cameraController)
        
        recognizer = RecognizePlate(delegate: self)
        currentRecord = DetectedRecord(detect_user:1)
    }
    
    func loadStatus(cmd:Int,deviceID:Int,value:String){
        print("\(cmd) \(deviceID) \(value)")
        switch cmd{
        case 0://车辆信息
            switch deviceID{
            case 3://称台下发的车辆信息：cmd:0,3,2/2.56/2
                let array2=value.componentsSeparatedByString("/")
               
                let axle_number = (array2[0] as NSString).integerValue
                
                
                currentRecord.setTruckInfo((array2[2] as NSString).floatValue , truck_type: truck_types.truckTypes[axle_number-1], axle_number: axle_number, speed: (array2[1] as NSString).floatValue )//轴型临时就这样

                detectStatus = btnStatusList.AutoSaving//数据获取完进入保存阶段
                self.delegate?.readDataModel(didGetStautsWithDataModel:self)
                
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
        currentRecord.resetDetectRecord()//新纪录 重新赋值检测记录的时间

        socket.send("cmd:2--") { () -> () in
            self.detectStatus = btnStatusList.Detecting
        }
        //self.cameraController.shoot()
        
    }
    
    func stopDetect(){
        
        
        socket.send("cmd:3--",dowork: {
            
        })//通知称台下发数据
        
    }
    
    func saveRecord(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),{
            
            self.currentRecord.saveInDb()
            self.detectStatus = btnStatusList.Saved//数据获取完进入保存阶段
            
        })
    }
    
    func cancelDetect(){
        socket.send("cmd:5--", dowork:{
            self.detectStatus = btnStatusList.Default//数据获取完进入保存阶段
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
        // watch
        var context = self.toDictForWatch()
        context["canPullStatus"] = true
        sessionManager.updateApplicationContext(context)
    }
}


extension DeviceStatusDataModel: CameraControllerDelegate {
    func cameraController(cameraController: CameraController, didShootSucceededWithImageData imageData: NSData) {
        
        let queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_async(queue) { [weak self]() -> Void in
            
            
            if let elf = self {
                let path = TNFileManager.getImagePath().stringByAppendingString(self!.currentRecord.getBigImageName())
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
        if recognizeResult.getError() == "Success" {
            
            self.currentRecord.plate_number = recognizeResult.getString()
            self.plateImage = UIImage(data: recognizeResult.getImage())!
        } else {
            self.currentRecord.plate_number =  "识别有误"
        }
    }
}


enum btnStatusList:Int{
    case Default = 0,Detecting, Analyzing, AutoSaving, Saved, Printing
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



//
//  UploadDetectedRecord.swift
//  datahander
//
//  Created by brainwang on 16/1/24.
//  Copyright © 2016年 brainwang. All rights reserved.
//

import Foundation
import SQLite
import Alamofire

let host:String="http://192.168.163.1"
let localImgPath:String=""

enum truck_types:String{
    case unknown = "未识别车型"
    case two = "两轴车"
    case three = "三轴车"
    case four = "四轴车"
    case five = "五轴车"
    case five_one = "五轴一型车"
    case five_two = "五轴二型车"
    case six_one = "六轴一型车"
    case six_two = "六轴二型车"
    static let truckTypes: [truck_types] = [.unknown, .two, .three, .four, .five, .five_one, .five_two, .six_one, .six_two]
    static let truckTypeRows: [truck_types: Int] = [.unknown: 0, .two: 1, .three: 2, .four: 3, .five: 4, .five_one: 5, .five_two: 6, .six_one: 7, .six_two: 8]
}



class DetectedRecord{
    var collection_id:Int = 0
    var isSavedCloud:Bool=false
    
    var plate_number:String="无车牌"
    var weight:Float=0.0
    var length:Float=0.0
    var width:Float=0.0
    var height:Float=0.0
    
    var truck_type:truck_types = .unknown
    var axle_number:Int=2
    var detect_time:NSDate=NSDate()
    //var detect_time_date: NSDate
    var speed:Float=0.0
    
    var detect_user:Int=1
    var plate_photo:String=""
    var truck_photo:String=""
    var detect_location:String=""
    var site_latitude:Double=0.0
    var latitude_dir:String="E"
    var site_longitude:Double=0.0
    var longitude_dir:String="N"
    
    let axle_numbers=(2,3,4,5,6)
    
    var over_weight:Float{
        get{
            if weight > Float(axle_number*10){
                return weight - Float(axle_number*10)
            }else{
                return 0.0
            }
        }
    }
    
    
    
    var over_height:Float{
        get{
            return 0.0
        }
    }
    var over_width:Float{
        return 0.0
    }
    
    var over_length:Float{
        return 0.0
    }
    
    var description:String{
        get{
            return "\(plate_number)，\(truck_type.rawValue)，速度：\(String(speed))千米，车重：\(weight)吨，\(over_weight>0 ? "超载\(over_weight)吨！" : "没有超载！")"
        }
    }
    
    //检测时新建一条记录时所用的构造函数
    init(detect_user:Int?){
        self.detect_user=detect_user==nil ? 0 : detect_user!
    }
    
    convenience init(id:Int, plate_number:String?,weight:Float,truck_type:truck_types?,axle_number:Int?,speed:Float?,
        detect_user:Int?,detect_time:NSDate?,plate_photo:String?,truck_photo:String?,
        location:String?,site_latitude:Double?,latitude_dir:String?,site_longitude:Double?,longtitude_dir:String?){
            //            self.init(id: id,plate_number: plate_number,weight: weight,truck_type: truck_type,axle_number: axle_number,speed: speed,detect_user: detect_user)
            self.init(detect_user:detect_user)
            self.collection_id=id
            
            let formatter=NSDateFormatter()
            formatter.dateFormat="yyyy-MM-dd HH:mm:ss"
            
            self.detect_time=detect_time == nil ? formatter.dateFromString("1970-01-01 00:00:00")!:detect_time!
            
            self.detect_user=detect_user == nil ? 0 : detect_user!
            
            setTruckInfo(weight, truck_type: truck_type, axle_number: axle_number, speed: speed)
            
            self.plate_number = plate_number==nil ? "" : plate_number!
            self.plate_photo = plate_photo==nil ? "" : plate_photo!
            self.truck_photo = truck_photo==nil ? "" : truck_photo!
            
            self.detect_location=location==nil ? "" : location!
            self.site_latitude=site_latitude==nil ? 0.0 : site_longitude!
            self.latitude_dir=latitude_dir==nil ? "N" : latitude_dir!
            self.site_longitude=site_longitude==nil ? 0.0 : site_longitude!
            self.longitude_dir=longtitude_dir==nil ? "E" : longtitude_dir!
    }
    
    
    
    
    ///services 
    
    func toDictForWatch () -> [String: AnyObject] {
        let formatter=NSDateFormatter()
        formatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        let dict: [String : AnyObject] = [
            "plateString": plate_number,
            "axleTypeString": truck_type.rawValue,
            "speedString": String(format: "%.1f km/h", speed),
            "weightString": String(format: "%.1f T", weight),
            "overWeigthString": String(format: "%.1f", over_weight),
            "datetimeString": formatter.stringFromDate(detect_time),
            "isOverWeight": over_weight > 0]
        
        return dict
    }
    
    
    //
    func resetDetectRecord(){
        let date:NSDate=NSDate()
        detect_time = date
        isSavedCloud=false
        plate_number="无车牌"
        weight=0.0
        length=0.0
        width=0.0
        height=0.0
        truck_type = .unknown
        axle_number=2
        speed=0.0
        plate_photo=""
        truck_photo=""
        detect_location=""
        site_latitude=0.0
        latitude_dir="E"
        site_longitude=0.0
        longitude_dir="N"
        
    }
    
    
    
    //basic car plate information
    
    //设置车辆速度 车轴信息
    func setTruckInfo(weight: Float?, truck_type: truck_types?, axle_number: Int?, speed: Float?) {
        self.weight = weight == nil ? 0.0 : weight!
        self.truck_type = truck_type == nil ? .unknown : truck_type!
        self.axle_number = axle_number == nil ? 0 : axle_number!
        self.speed = speed == nil ? 0.0 : speed!
    }
    
    
    //设置车牌信息,用于摄像头拍照、车牌识别后设置识别信息
    func setPlateInfo(plateNum:String){
        self.plate_number=plateNum
        
        let formatter=NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let detect_timeStr = formatter.stringFromDate(self.detect_time)
        
        plate_photo = detect_timeStr
        truck_photo = detect_timeStr+"_big.jpg"
        
    }
    
    
    //set location informations of record
    func setLocation(location:String,site_latitude:Double,latitude_dir:String,site_longitude:Double,longtitude_dir:String){
        self.detect_location=location
        self.site_latitude=site_latitude
        self.latitude_dir=latitude_dir
        self.site_longitude=site_longitude
        self.longitude_dir=longtitude_dir
    }
    //获取大图文件名,如果没有没有参数传入就是 "yyyy-MM-dd-HH:mm:ss"
    func getBigImageName()->String{
        let formatter=NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let detect_timeStr = formatter.stringFromDate(self.detect_time)
        
        return detect_timeStr+"_big.jpg";
    }
    
    //获取小图文件名
    func getSmallImageName()->String{
        let formatter=NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let detect_timeStr = formatter.stringFromDate(self.detect_time)
        
        return detect_timeStr+".jpg"
    }
    
    
    
    func saveInDb()->Bool{
        let db=DBAdapter()
        db.insertDetectRecord(self)
        
        return false
    }
    
    
    //get all record with a number limit
    class func getRecordsWithNumber(number:Int = 0)->[DetectedRecord]{
        let dataBase:DBAdapter = DBAdapter()
        var records: [DetectedRecord] = []
       
        let formatter = NSDateFormatter()
        formatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        for arecord in (dataBase.getAllRecords(number))!{
            print(arecord)
            
            print(arecord[dataBase.plate_number])
            print(arecord.get(dataBase.axle_number))
            print(arecord.get(dataBase.over_weight))
            
            print(arecord[dataBase.weight])
            print(arecord.get(dataBase.speed))
            print(arecord.get(dataBase.detect_time))
            
            records.append(DetectedRecord(
                id: arecord[dataBase.id],
                plate_number: arecord[dataBase.plate_number],
                weight: (Float)(arecord[dataBase.weight]==nil ? 0.0 : arecord[dataBase.weight]!),
                truck_type: truck_types(rawValue:arecord[dataBase.truck_type]!)!,
                axle_number: arecord[dataBase.axle_number],
                speed: (Float)(arecord[dataBase.speed]==nil ? 0.0 : arecord[dataBase.speed]!),
                detect_user: arecord[dataBase.user_id]!,
                detect_time:formatter.dateFromString(arecord[dataBase.detect_time] == nil ? "1970-01-01 00:00:00" : arecord[dataBase.detect_time]!),
                plate_photo: arecord[dataBase.plate_photo],
                truck_photo: arecord[dataBase.truck_type],
                location:arecord[dataBase.detect_location],
                site_latitude: arecord[dataBase.site_latitude],
                latitude_dir: arecord[dataBase.latitude_dir],
                site_longitude: arecord[dataBase.site_longitude],
                longtitude_dir: arecord[dataBase.longtitude_dir]
                )
            )
        }
        return records

    }
    
    
    //upload record to server
    func uploadRecordToCloud(){
        var result=false
        Alamofire.request(.POST,
            host+"/DetectRecord/create",
            parameters:[
                "collection_id": collection_id,
                "plate_number":plate_number,
                "weight":weight,
                "over_weight":over_weight,
                "axle_number":axle_number,//2，3，4，5，6
                "truck_type":truck_type.rawValue,
                "length":length,
                "over_length":over_length,
                "width":width,
                "over_width":over_width,
                "height":height,
                "over_height":over_height,
                "speed":speed,
                "plate_photo":openImageBase64(plate_photo),
                "truck_photo":openImageBase64(truck_photo),
                "detect_time":detect_time,
                "detect_user":detect_user,
                "detect_location":detect_location,
                "site_latitude":site_latitude,
                "latitude_dir":latitude_dir,
                "site_longitude":site_longitude,
                "longitude_dir":longitude_dir ]
            
            )
            .responseJSON { (response) in
                switch response.result{
                case .Success(let value):
                    if let kv=value as? NSDictionary{
                        
                        if let status=kv.valueForKey("status"){
                            result = (status.description=="200")
                        }
                        
                    }
                case .Failure(let error):
                    print("上传失败：error：\(error)")
                }
                
        }
        //return result
    }
    
    
    //打开指定路径图片转化为base64编码
    private func openImageBase64(imageName:String)->String{
        let path = NSURL(string: imageName, relativeToURL: NSURL(string: TNFileManager.getImagePath()))
        do{
            let data = try NSData(contentsOfURL: path!, options: .DataReadingMapped)
            let base64String=data.base64EncodedStringWithOptions(.EncodingEndLineWithLineFeed)
            return base64String
        }catch let e as NSError{
            print(e)
            return ""
        }
    }
    
    
}
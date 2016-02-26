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
    case two="两轴车"
    case three="三轴车"
    case four="四轴车"
    case five="五轴车"
    case five_one="五轴一型车"
    case five_two="五轴二型车"
    case six_one="六轴一型车"
    case six_two="六轴二型车"
}


class DetectedRecord{
    var collection_id:Int
    var isSavedCloud:Bool=false
    
    var plate_number:String="无车牌"
    var weight:Float=0.0
    var length:Float=0.0
    var width:Float=0.0
    var height:Float=0.0
    
    var truck_type:String="未识别车型"
    var axle_number:Int
    var detect_time:String
    var detect_time_date: NSDate
    var speed:Float=0.0
    
    var detect_user:Int=1
    var plate_photo:String=""
    var truck_photo:String=""
    var detect_location:String=""
    var site_latitude:String="0.0"
    var latitude_dir:String="E"
    var site_longitude:String="0.0"
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
            return "\(plate_number),\(truck_type);速度:\(String(speed))千米"
        }
    }
    
    //basic car plate information
    init(id:Int, plate_number:String,weight:Float,truck_type:String,axle_number:Int,speed:Float,detect_user:Int){
        collection_id=id
        self.plate_number=plate_number
        self.weight=weight
        self.truck_type=truck_type
        self.axle_number=axle_number
        let date:NSDate=NSDate()
        detect_time_date = date
        let formatter=NSDateFormatter()
        formatter.dateFormat="yyyy-MM-DD HH:mm:ss"
        self.detect_time=formatter.stringFromDate(date)
        self.speed=speed
        self.detect_user=detect_user
    }
    
    //设置车牌信息
    func setPlateInfo(plateNum:String){
        
    }
    
    //
    class func getBigImageName(){
        
    }
    
    
    convenience init(id:Int, plate_number:String,weight:Float,truck_type:String,axle_number:Int,speed:Float,
        detect_user:Int,plate_photo:String,truck_photo:String,
        location:String,site_latitude:String,latitude_dir:String,site_longitude:String,longtitude_dir:String){
            self.init(id: id,plate_number: plate_number,weight: weight,truck_type: truck_type,axle_number: axle_number,speed: speed,detect_user: detect_user)
            self.plate_photo=plate_photo
            self.truck_photo=truck_photo
            self.detect_location=location
            self.site_latitude=site_latitude
            self.latitude_dir=latitude_dir
            self.site_longitude=site_longitude
            self.longitude_dir=longtitude_dir
    }
    
    
    //set location informations of record
    func setLocation(location:String,site_latitude:String,latitude_dir:String,site_longitude:String,longtitude_dir:String){
        self.detect_location=location
        self.site_latitude=site_latitude
        self.latitude_dir=latitude_dir
        self.site_longitude=site_longitude
        self.longitude_dir=longtitude_dir
    }
    
    
    
    func saveInDb()->Bool{
        let db=DBAdapter()
        db.insertDetectRecord(self)
        
        return false
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
                "truck_type":truck_type,
                "length":length,
                "over_length":over_length,
                "width":width,
                "over_width":over_width,
                "height":height,
                "over_height":over_height,
                "speed":speed,
             //   "plate_photo":openImageBase64(plate_photo),
               // "truck_photo":openImageBase64(truck_photo),
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
                            result=(status.description=="200")
                            
                        }
                        
                    }
                case .Failure(let error):
                    print("上传失败：error：\(error)")
                }
                
        }
        //return result
    }
    
    
    //打开指定路径图片转化为base64编码
//    private func openImageBase64(imageName:String)->String{
//        let path=NSURL(string: imageName, relativeToURL: TNFileManager.getImagePath())
//        do{
//            let data=try NSData(contentsOfURL: path!, options: .DataReadingMapped)
//            let base64String=data.base64EncodedStringWithOptions(.EncodingEndLineWithLineFeed)
//            return base64String
//        }catch let e as NSError{
//            print(e)
//            return ""
//        }
//    }
    
    
}
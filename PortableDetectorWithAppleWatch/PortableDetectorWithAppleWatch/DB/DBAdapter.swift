//
//  DBAdapter
//  webserivceAndDB
//根据实际需求完成数据库操作的类
//  Created by brainwang on 16/2/21.
//  Copyright © 2016年 brainwang. All rights reserved.
//

import Foundation
import SQLite

class DBAdapter {
    //数据库表名
    var T_USERS = "users";
    var T_DETECTRECORD = "detect_record";
    var T_CALIBRATEDATA = "calibrate_data";
    //
    //数据表列名expression
    //数据库记录表,weight等量之所以为Double是因为‘<-’插入记录时不支持float<>
    
    let  userName=Expression<String>("name")
    let  id=Expression<Int>("id")
    let  detect_time=Expression<String?>("detect_time")
    let  isSync=Expression<Int?>("isSync")
    let  user_id=Expression<Int?>("user_id")
    let  detect_location=Expression<String?>("detect_location")
    let  site_latitude=Expression<Double?>("site_latitude")
    let  latitude_dir=Expression<String?>("latitude_dir")
    let  site_longitude=Expression<Double?>("site_longitude")
    let  longtitude_dir=Expression<String?>("longtitude_dir")
    
    let  plate_number=Expression<String?>("plate_number")
    let  truck_photo=Expression<String?>("truck_photo")
    let  plate_photo=Expression<String?>("plate_photo")
    let  axle_number=Expression<Int?>("axle_number")
    let  truck_type=Expression<String?>("truck_type")
    let  speed=Expression<Double?>("speed")
    let  weight=Expression<Double?>("weight")
    let  over_weight=Expression<Double?>("over_weight")
    let  length=Expression<Double?>("length")
    let  over_length=Expression<Double?>("over_length")
    let  width=Expression<Double?>("width")
    let  over_width=Expression<Double?>("over_width")
    let  height=Expression<Double?>("height")
    let  over_height=Expression<Double?>("over_height")

    var database:Connection?
    
    
    init(){
        database=DBHelper().database
    }
    
    deinit{
        
        //database.
    }
    //插入新纪录,返回插入的id
    func insertDetectRecord(record:DetectedRecord)->Int64?{
        var new_id:Int64=0
        let formatter=NSDateFormatter()
        formatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        let detect_timeStr=formatter.stringFromDate(record.detect_time)
        
        do{
            try new_id=(database?.run(Table(T_DETECTRECORD).insert(
                isSync <- 0,
                detect_time <- detect_timeStr,
                 user_id<-record.detect_user,
                detect_location <- record.detect_location,
                
                site_latitude <- record.site_latitude,
                latitude_dir <- record.latitude_dir,
                site_longitude <- record.site_longitude,
                longtitude_dir <- record.longitude_dir,
                
                plate_number <- record.plate_number,
                truck_photo <- record.truck_photo,
                plate_photo <- record.plate_photo,
                axle_number <- record.axle_number,
                truck_type <- record.truck_type.rawValue,
                speed <- (Double)(record.speed),
                weight <- Double(record.weight),
                over_weight <- Double(record.over_weight),
                length <- Double(record.length),
                over_length <- Double(record.over_length),
                width <- Double(record.width),
                over_width <- Double(record.over_width),
                height <- Double(record.height),
                over_height <- Double(record.over_height)
                
                )))!
        }catch let e as NSError{
            print(e)
        }
        
        return new_id
    }
    
    //获取纪录by id
    func getRecordById(record_id:Int)->DetectedRecord?{
        var record:DetectedRecord
        let select=Table(T_DETECTRECORD).filter(id==record_id)
        
        let formatter=NSDateFormatter()
        formatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        
        
        do{
            for arecord in (try database?.prepare(select))!{
                record=DetectedRecord(
                    id: record_id,
                    plate_number: arecord[plate_number],
                    weight: (Float)(arecord[weight]==nil ? 0.0 : arecord[weight]!),
                    truck_type: truck_types(rawValue:arecord[truck_type]!)!,
                    axle_number: arecord[axle_number],
                    speed: (Float)(arecord[speed]==nil ? 0.0 : arecord[speed]!),
                    detect_user: arecord[user_id]!,
                    detect_time:formatter.dateFromString(arecord[detect_time] == nil ? "1970-01-01 00:00:00" : arecord[detect_time]!),
                    plate_photo: arecord[plate_photo],
                    truck_photo: arecord[truck_type],
                    location:arecord[detect_location],
                    site_latitude: arecord[site_latitude],
                    latitude_dir: arecord[latitude_dir],
                    site_longitude: arecord[site_longitude],
                    longtitude_dir: arecord[longtitude_dir])
                return record
            }
            
        }catch let e as NSError{
            print(e)
            return nil
        }
        return nil
    }
    //删除记录by id
    func deleteRecordByid(record_id:Int)->Bool{
        let select=Table(T_DETECTRECORD).filter(id==record_id)
        do{
            try database!.run(select.delete())
            return true
        }catch{
            
            return false
        }
    }
    
    //按检测时间排序获取所有记录,遍历方式： for single_record in (getAllRecords())!
    func getAllRecords(recordNumber:Int = 0) -> AnySequence<Row>? {
        var select = Table(T_DETECTRECORD).order(detect_time.desc)
        if recordNumber > 0{
            select = select.limit(recordNumber)
            
        }
        do{
            let result = (try database?.prepare(select))
            print(result)
            return result
            
        }catch{
            return nil
        }
        
    }
    
    //get all detect user
    
    func getAllUser()->AnySequence<Row>?{
        let select=Table(T_USERS)
        do{
            let result=(try database?.prepare(select))
            return result
            
        }catch{
            return nil
        }
    }
    
    
    
}
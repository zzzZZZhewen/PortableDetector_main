//
//  DBHelper.swift
//  创建和链接数据库的帮助类，实际的功能实现是有DBAdapter完成
//
//  Created by brainwang on 16/1/27.
//  Copyright © 2016年 brainwang. All rights reserved.
//

import Foundation
import SQLite
class DBHelper{
    var dbPath:String?=NSSearchPathForDirectoriesInDomains( .DocumentDirectory,
    .UserDomainMask, true ).first!
    var dbFilename="portable_balance"
    var database:Connection?
    
    
    
    init(){
        assert(createDBFileIfNeeded(),"数据库创建失败")
         let DBfile=dbPath!+"/\(dbFilename)"
        database=try! Connection(DBfile)
    }
    
    //数据库文件不存在或者首次首次安装时，复制数据库文件到资源沙盒的doucument，目录下
    func createDBFileIfNeeded()->Bool{
        let fileManager=NSFileManager.defaultManager()
        let DBfile=dbPath!+"/\(dbFilename)"
        print(DBfile)
        let dbfileExits=fileManager.fileExistsAtPath(DBfile)
        if !dbfileExits{
            let defaultDBPath:String? = NSBundle.mainBundle().pathForResource(dbFilename, ofType: "sqlite")
                 do{
                 try fileManager.copyItemAtPath(defaultDBPath!, toPath: DBfile)
                    return true
                 }catch let error as NSError {
                print("数据库创建错误\(error)")
                    return false
            }
        }else{
                return true
            }
        
    }
    
      
}
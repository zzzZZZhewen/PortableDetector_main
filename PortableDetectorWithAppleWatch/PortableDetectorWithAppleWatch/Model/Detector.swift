//
//  Detector.swift
//  UIPrototype
//
//  Created by 缪哲文 on 16/2/25.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit

class Detector {
    var detectorName = "全部"
    var detectorID = 0
    
    init(id: Int, name: String) {
        detectorName = name
        detectorID = id
    }
    
    class func getAllDetectors()->[Detector]{
        let dataBase = DBAdapter()
        var conductors:[Detector] = []
        for single_record in (dataBase.getAllUser())!{
            print(single_record[dataBase.userName])
            conductors.append(Detector(id:single_record[dataBase.id],name:single_record[dataBase.userName]))
        }
        return conductors
    }
}

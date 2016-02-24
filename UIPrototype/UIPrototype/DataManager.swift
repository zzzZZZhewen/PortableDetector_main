//
//  DataManager.swift
//  UIPrototype
//
//  Created by 缪哲文 on 16/2/23.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit

protocol DataManagerDelegate {
    func datamanager(manager: DataManager, didReadAValue: AnyObject, forKey key: String)
}

class DataManager: NSObject {

}

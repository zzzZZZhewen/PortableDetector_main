//
//  DocumentManager.swift
//  PortableDetector
//
//  Created by 缪哲文 on 16/1/21.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import Foundation


protocol DataDealerDelegate {
    
    func didGetPlateString(plateString: String)
    func didGetBatteryAValue(value : Int)
    
}

class DataDealer {
    
    var delegate : DataDealerDelegate!
    
    typealias Completion = (result: AnyObject?, error: NSError?) -> ()
    
    func reading() {
        
        
        //case
        // dispatch
        
        CameraManager.sharedManager.shoot("haha.png" , completion: { (result, error) -> () in
            
            var flag = result as! Bool
            
            if flag {
                PlateManager.sharedManager.recognize("haha.png") { (result, error) -> () in
                    
                    var plateString  = result as! String
                    
                    // save
                    
                    
                    if delegate != nil {
                        
                        delegate.didGetPlateString(plateString)
                    }
                    
                    
                }
            }
            
        });
        
        //end dispatch
        
        //end case
    }
}
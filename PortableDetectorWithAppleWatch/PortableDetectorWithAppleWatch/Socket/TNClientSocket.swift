//
//  TNSocket.swift
//  UIPrototype
//
//  Created by brainwang on 16/2/24.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import ysocket
import Foundation
import Darwin.C
protocol TNClientSocketMsgDelegate:class{
    func  updateFromSocket(content:Dictionary<String,AnyObject>)
}

class TNClientSocket:TCPClient{
    
    weak var delegate:TNClientSocketMsgDelegate?
    init(delegate:TNClientSocketMsgDelegate){
        self.delegate=delegate
        super.init(addr: socketInfo.weightAHost,port: socketInfo.weightAPort)
    }
    
    func startRead()->(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            let (success,msg)=self.connect(timeout: 3)
            if success{
                while(true){
                    let data=self.read(1024)
                    if let d=data{
                        if let str=String(bytes: d, encoding: NSUTF8StringEncoding){
                            // print(str)
                            let myStrings = str.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
                            for i in myStrings{
                                //print(i)
                                if(i.hasPrefix("cmd:")){
                                    
                                    self.delegate?.updateFromSocket(self.processRawData(i)!)//通知上层更新
                                }
                                
                            }
                        }
                    }else{
                        //将来在这里执行重连。。。
                        print("断掉")
                    }
                    
                    usleep(10000)
                }
                
            }else{
                self.delegate?.updateFromSocket(["success":false,"msg":msg])
            }
            
        })
    }
    
    //处理原始数据
    func processRawData(data:String)->[String:AnyObject]?{
        let data=data.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if data.hasPrefix("cmd:"){
            
            let index=data.startIndex.advancedBy(4)
            let range=Range(start: index,end: data.endIndex)
            let result:String=data.substringWithRange(range)
            let array1=result.componentsSeparatedByString("--")
            let cmdindex=(array1[0] as NSString).integerValue
            let content=array1[1]
            let array2=content.componentsSeparatedByString(",")
            let deviceID=(array2[0]as NSString).integerValue
            let value=array2[1]
            return ["success":true,"cmd":"\(cmdindex)","deviceID":deviceID,"value":"\(value)"]
            
            
            
        }else{
            return nil
        }
        
    }
    //
    func send(string: String,dowork:()->()){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            
            let (success,msg)=super.send(str: "\(string)\n")
            if success{
                dowork()
            }
                else{
                    self.delegate?.updateFromSocket(["success":false,"msg":"指令发送失败：\(msg)"])
                }
            
        })
        
    }
    
}
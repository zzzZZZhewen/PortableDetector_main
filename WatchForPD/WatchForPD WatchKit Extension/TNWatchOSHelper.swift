//
//  TNwatchOSHelper.swift
//  WatchForPD
//
//  Created by 缪哲文 on 16/1/29.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import WatchKit

class TNWatchOSHelper: NSObject {
    
}

public enum TNFontIcon : String {
    case Battery0 = "\u{e608}"
    case Battery1 = "\u{e609}"
    case Battery2 = "\u{e606}"
    case Battery3 = "\u{e605}"
    
    static let batteryStatus = [Battery0, Battery1, Battery2, Battery3]
    
    case Signal0 = "\u{e620}"
    case Signal1 = "\u{e602}"
    case Signal2 = "\u{e601}"
    case Signal3 = "\u{e600}"
    case Signal4 = "\u{e615}"
    
    static let signalStatus = [Signal0, Signal1, Signal2, Signal3, Signal4]
    
    case BalanceA = "\u{e603}"
    case BalanceB = "\u{e604}"
    
    case Automobile = "\u{e622}"
    case Dashboard = "\u{e60b}"
    
    case Print = "\u{e610}"
    case Save = "\u{e61b}"
    case Applewatch = "\u{e621}"
    case Weight = "\u{e626}"
    case LanConnected = "\u{e607}"
    case LanDisConnected = "\u{e60c}"
    case Blance = "\u{e623}"
    case Mobile = "\u{e624}"
    case MinusCircle = "\u{e60d}"
    case Play = "\u{e611}"
    case PowerOff = "\u{e60f}"
    case Spinner = "\u{e613}"
    case ThList = "\u{e614}"
    case Trash = "\u{e616}"
    case Tag = "\u{e617}"
    case Refresh = "\u{e612}"
    case Stop = "\u{e61c}"
    case Warning = "\u{e61f}"
}
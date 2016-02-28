//
//  theme.swift
//  UIPrototype
//
//  Created by 缪哲文 on 16/2/18.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit

public let NavigationH: CGFloat = 64
public let AppWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
public let AppHeight: CGFloat = UIScreen.mainScreen().bounds.size.height
public let MainBounds: CGRect = UIScreen.mainScreen().bounds

struct theme {
    ///  APP导航条barButtonItem文字大小
    static let SDNavItemFont: UIFont = UIFont.systemFontOfSize(16)
    ///  APP导航条titleFont文字大小
    static let SDNavTitleFont: UIFont = UIFont.systemFontOfSize(18)
    /// ViewController的背景颜色
    static let SDBackgroundColor: UIColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    /// webView的背景颜色
    static let SDWebViewBacagroundColor: UIColor = UIColor(red: 245, green: 245, blue: 245, alpha: 1)
    /// 友盟分享的APP key
    static let UMSharedAPPKey: String = "55e2f45b67e58ed4460012db"
    /// 自定义分享view的高度
    static let ShareViewHeight: CGFloat = 215
    static let GitHubURL: String = "https://github.com/ZhongTaoTian"
    static let JianShuURL: String = "http://www.jianshu.com/users/5fe7513c7a57/latest_articles"
    /// cache文件路径
    static let cachesPath: String = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last!
    /// UIApplication.sharedApplication()
    static let appShare = UIApplication.sharedApplication()
    static let sinaURL = "http://weibo.com/u/5622363113/home?topnav=1&wvr=6"
    /// 高德地图KEY
    static let GaoDeAPPKey = "2e6b9f0a88b4a79366a13ce1ee9688b8"
}

public let AxleStyleArray: [String] = ["两轴车","三轴车"]

//socket
struct socketInfo{
   static let weightAHost = "192.168.216.1"
   static let weightAPort = 800
    
   static let weightBHost = "192.168.216.1"
   static let weightBPort = 800
   
    static let printerHost = "192.168.216.1"
    static let printerPort = 800
    
   static let coilSensorHost = "192.168.216.1"
   static let coilSensorPort = 800
}

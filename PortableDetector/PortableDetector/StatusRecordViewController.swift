//
//  ExampleViewController.swift
//  样例controller 最后不会使用
//
//  Created by 缪哲文 on 16/1/20.
//  Copyright © 2016年 缪哲文. All rights reserved.
//
    // 代码格式：
    // 定义接口
    // 定义类
    // 属性
    // 生命周期
    // 代理和数据源的实现
    // 其他协议实现
    // 事件响应
    // getters 和 setters（包括IBOUTLET）
    // 定义扩展 extension
    // 代理和数据源的实现
    // 其他协议实现
    // ...




import UIKit
import AVFoundation


/// 主页面，用来显示检测状态（status）和最近一条记录（record）
/// 业务逻辑在 StatusRecordModel中实现
class StatusRecordViewController: UIViewController {
    
//MARK - properties
    /// 一个StatusRecordViewController对应的业务逻辑
    var model = StatusRecordModel()
    
//MARK - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
    
        //不要在viewDidLoad里面初始化你的view然后再add，这样代码就很难看。
        //在viewDidload里面只做addSubview的事情，
        //然后在viewWillAppear里面做布局的事情（这里在最后还会讨论），
        //最后在viewDidAppear里面做Notification的监听之类的事情。
        //至于属性的初始化，则交给getter去做。
     
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK - 苹果API的代理和数据源
//如：
//MARK - UITableViewDelegate
    
//MARK - 自定义的代理
    
//MARK - event response
        // 响应开始按钮
        // dispatch
        // model.startReadingDucoment()
        // end dispatch
    
    //...

//MARK - public methods
    
//MARK - private methods
  
    //一般不存在私有方法，小功能要么把它写到TNiOSHelper里面，要么把他做成一个Manager
    
//MARK - getters and setters
    
    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var aView: UIView!
    //...

//MARK - 其他

}

//MARK - extention

//MARK - RecordModelDelegate
extension StatusRecordViewController : StatusRecordModelDelegate {
    //所有字符串都得到以后更新视图 去掉现在图片 等待加载图片
    //缪：我的想法是 这里虽然以车牌为例 但是车牌可能是最后才识别出来，所以可以先显示车辆是否超重和其他信息
    func didGetAllString() {
        /// ViewController控制的View可以直接使用业务逻辑中的字符串来更新页面
        // self.aLabel = self.model.statusString
    }
}
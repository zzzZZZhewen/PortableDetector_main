//
//  ExampleViewController.swift
//  PortableDetector
//
//  Created by 缪哲文 on 16/1/20.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit
import AVFoundation

class ExampleViewController: UIViewController, RecordModelDelegate {

    var model = RecordModel()
    
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
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - UITableViewDelegate
    
    // ...
    
    //MARK - CustomDelegate
    
    //MARK - RecordModelDelegate
    
    func didGetPlateNumber(plate: String) {
        aLabel.text = plate
    }
    
    //...
    
    //MARK - event response
    @IBAction func aButtonDidTouchUpInside(sender: AnyObject) {
        weak var tmpSelf = self
        
        for i in 0...4 {
            let time = dispatch_time(DISPATCH_TIME_NOW,Int64(Double(i) * 1.2 * Double(NSEC_PER_SEC)))

            dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
            tmpSelf!.aLabel.text = String(i)
            
            }
        }
        
        
    }

    @IBAction func takepicButtonDidTouchUpInside(sender: AnyObject) {
        // dispatch
        // model.startReadingDucoment()
        // end dispatch
    }
    //...
    
    //MARK - private methods
  
    //一般不存在私有方法，小功能要么把它写成一个category，要么把他做成一个模块
    
    //MARK - getters and setters
    @IBOutlet weak var aLabel: UILabel!
    
    @IBOutlet weak var aView: UIView!
    //...

}

// MARK - extention
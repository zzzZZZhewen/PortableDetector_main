//
//  ViewController.swift
//  WatchForPD
//
//  Created by 缪哲文 on 16/1/28.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func buttonClicked(sender: AnyObject) {
        viewModel.startTesting()
        
    }
    @IBAction func sendNilStatusButtonTapped(sender: AnyObject) {
        viewModel.clear()
    }
    @IBAction func buttonSendARecordTapped(sender: AnyObject) {
        viewModel.pushRecord()
    }
}


//
//  ViewController.swift
//  hangge_921
//
//  Created by yuhang on 15/11/5.
//  Copyright © 2015年 yuhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        stitch()
    }
    
    func stitch() {
        //由于图片拼接很费时,显示环形进度条
        self.spinner.startAnimating()
        //在后台队列拼接图片
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let image1 = UIImage(named:"IMG_4247.JPG")
            let image2 = UIImage(named:"IMG_4248.JPG")
            let image3 = UIImage(named:"IMG_4249.JPG")
            let image4 = UIImage(named:"IMG_4250.JPG")
            
            let imageArray:[UIImage!] = [image1,image2,image3,image4]
            
            let stitchedImage:UIImage = CVWrapper.processWithArray(imageArray) as UIImage
        
            dispatch_async(dispatch_get_main_queue(), {
                self.imageView.image = stitchedImage
                //停止环形进度条效果
                self.spinner.stopAnimating()
            })
         
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


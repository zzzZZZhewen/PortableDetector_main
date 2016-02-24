//
//  StatusViewController.swift
//  UIPrototype
//
//  Created by 缪哲文 on 16/2/21.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit
import AVFoundation

class StatusViewController: UIViewController {
    
    var viewModel: StatusViewModel!
    
    @IBOutlet weak var balanceAIcon: UIImageView!
    @IBOutlet weak var balanceBIcon: UIImageView!
    @IBOutlet weak var instrumentIcon: UIImageView!
    @IBOutlet weak var automobileIcon: UIImageView!
    @IBOutlet weak var cameraPreview: UIView!
    @IBOutlet weak var lastRecordPlate: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = StatusViewModel(delegate: self)
        self.setIcons()
        //self.setCamera()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let previewLayer = viewModel.cameraController?.videoPreviewLayer {
            previewLayer.frame = cameraPreview.bounds
            previewLayer.connection.videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.currentDevice().orientation.rawValue)!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func startButtonTappedInside(sender: AnyObject) {
        self.viewModel.shoot()
    }
    
    
    // MARK: - private
    
    func setIcons() {
        self.balanceAIcon.tintColor = UIColor(red: 236/255, green: 63/255, blue: 140/255, alpha: 1.0)
        self.balanceBIcon.tintColor = UIColor(red: 236/255, green: 63/255, blue: 140/255, alpha: 1.0)
        self.instrumentIcon.tintColor = UIColor(red: 57/255, green: 177/255, blue: 198/255, alpha: 1.0)
        self.automobileIcon.tintColor = UIColor(red: 57/255, green: 177/255, blue: 198/255, alpha: 1.0)
    }
    
    func setCamera() {
        viewModel.initCameraController()
        if let previewLayer = viewModel.cameraController.videoPreviewLayer {
            previewLayer.frame = cameraPreview.bounds
            cameraPreview.layer.addSublayer(previewLayer)
        }
    }
}

extension StatusViewController: StatusViewModelDelegate {
    func statusViewModel(viewModel:StatusViewModel, didShootSucceededWithImage image: UIImage) {
        lastRecordPlate.image = image
    }
}

